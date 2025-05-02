import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { GoalDTO, GoalUpdateDTO } from './dto/goals.dto';
import { NotificationsService } from '../notifications/notifications.service';
import { Goal, GoalType } from '@prisma/client';
import { CronService } from '../../cron/cron.service';

@Injectable()
export class GoalsService {
  constructor(
    private prisma: PrismaService,
    private readonly notificationsService: NotificationsService,
    private readonly cronService: CronService,
  ) {}

  private readonly logger = new Logger(GoalsService.name);

  async create(userId: number, data: GoalDTO) {
    const [hours, minutes] = data.notificationTime.split(':').map(Number);
    const notificationTime = (hours + 3) * 60 * 60 * 1000 + minutes * 60 * 1000;
    const startDate = new Date(
      new Date(data.startDate).getTime() + notificationTime,
    );

    const endDate = new Date(
      new Date(data.endDate).getTime() + notificationTime,
    );

    const goal = await this.prisma.goal.create({
      data: {
        userId,
        type: data.type,
        targetAmount: data.targetAmount,
        startDate,
        endDate,
        allowNotifications: data.allowNotifications,
        // Take into account argentina timezone
        notificationTimeHour: hours,
        notificationTimeMinutes: minutes,
      },
    });

    await this.setNotificationCreationJobs(goal);

    return goal;
  }

  async setNotificationCreationJobs(goal: Goal) {
    const totalGoalTime = goal.endDate.getTime() - goal.startDate.getTime();
    const elapsedTime = Date.now() - goal.startDate.getTime();

    const goalNotificationBreakpoints = [0.5, 0.8, 1];

    goalNotificationBreakpoints.forEach((breakpoint) => {
      const notificationDate = new Date(
        totalGoalTime * breakpoint + goal.startDate.getTime(),
      );

      notificationDate.setHours(
        goal.notificationTimeHour,
        goal.notificationTimeMinutes,
        0,
        0,
      );

      if (totalGoalTime * breakpoint < elapsedTime) {
        this.logger.error(
          `Goal ${goal.id} has negative time for breakpoint ${breakpoint}: ${notificationDate} ${new Date()}`,
        );
        return;
      }

      const notificationTime = notificationDate.getTime() - Date.now();

      const notificationFn =
        breakpoint === 1
          ? () => this.checkGoalFinished(goal.id)
          : () => this.checkGoalProgress(goal.id, breakpoint);

      this.cronService.addTask(
        `goal-${goal.id}-notification-${breakpoint}`,
        notificationTime,
        notificationFn,
      );
      this.logger.log(
        `Added notification task for goal ${goal.id} at ${breakpoint}: ${notificationDate} ${notificationTime})}`,
      );
    });
  }

  private convertTimeToDate(time: number, date: Date) {
    return new Date(time + date.getTime());
  }

  async getUserGoals(userId: number) {
    return this.prisma.goal.findMany({
      where: { userId },
    });
  }

  async updateGoalProgress(id: number, updateData: GoalUpdateDTO) {
    const goal = await this.prisma.goal.findUnique({
      where: { id },
    });

    if (!goal) {
      throw new Error('Goal not found');
    }

    const newAmountRead = goal.amountRead + updateData.amountRead;
    const newProgress = Math.min(
      (newAmountRead / goal.targetAmount) * 100,
      100,
    );
    const isCompleted = newAmountRead >= goal.targetAmount;

    const updatedGoal = await this.prisma.goal.update({
      where: { id },
      data: {
        amountRead: newAmountRead,
        progress: Math.round(newProgress),
        completed: isCompleted,
        allowNotifications: updateData.allowNotifications,
      },
    });

    if (isCompleted) {
      this.checkGoalFinished(id);
      this.cancelGoalNotifications(id);
    }

    return updatedGoal;
  }

  cancelGoalNotifications(id: number) {
    this.cronService.removeTimeout(`goal-${id}-notification-0.5`);
    this.cronService.removeTimeout(`goal-${id}-notification-0.8`);
    this.cronService.removeTimeout(`goal-${id}-finished`);
  }

  async delete(id: number) {
    return this.prisma.goal.delete({
      where: { id },
    });
  }

  // @Cron('0 0 * * *')
  // async checkGoalProgressCron() {
  //   await this.checkGoalsProgress();
  // }

  // async checkGoalsProgress() {
  //   const goals = await this.prisma.goal.findMany({
  //     where: { completed: false },
  //     include: { user: true },
  //   });

  //   await Promise.all(goals.map((goal) => this.checkGoalProgress(goal)));
  // }

  async checkGoalProgress(goalId: number, breakpoint: number) {
    const goal = await this.prisma.goal.findUnique({
      where: { id: goalId },
    });
    if (!goal?.allowNotifications) {
      return;
    }
    const elapsedTime =
      (Date.now() - new Date(goal.startDate).getTime()) /
      (goal.endDate.getTime() - goal.startDate.getTime());
    const expectedProgress = Math.floor(elapsedTime * 100);

    const goalType = goal.type == GoalType.BOOKS ? 'libros' : 'páginas';

    let header: string;
    if (breakpoint === 0.5) {
      header = '¡Vas por la mitad de tu meta!';
    } else if (breakpoint === 0.8) {
      header = '¡Ya falta poco para que termine tu meta!';
    }

    this.logger.log(
      `Checking goal ${goal.id} progress at ${breakpoint}: ${expectedProgress} vs ${goal.progress}`,
    );

    // Add leeeway of 1% to avoid user just under progress
    if (goal.progress + 1 >= expectedProgress) {
      await this.notificationsService.createNotification(
        goal.userId,
        goal.id,
        `${header} ¡Excelente progreso en la meta de leer ${goal.targetAmount} ${goalType}! ¡Sigue así!`,
      );
    } else if (goal.progress < expectedProgress) {
      await this.notificationsService.createNotification(
        goal.userId,
        goal.id,
        `${header} ¡Ánimo! Estás un poco detrás de tu meta de leer ${goal.targetAmount} ${goalType}, pero no te desanimes. ¡Tú puedes lograrlo! Cada ${goalType.slice(0, -1)} cuenta, sigue adelante.`,
      );
    }
  }

  async checkGoalFinished(goalId: number) {
    const goal = await this.prisma.goal.findUnique({
      where: { id: goalId },
    });
    if (!goal?.allowNotifications) {
      return;
    }

    const elapsedTime =
      (Date.now() - new Date(goal.startDate).getTime()) /
      (goal.endDate.getTime() - goal.startDate.getTime());
    const expectedProgress = elapsedTime * 100;

    const goalType = goal.type == GoalType.BOOKS ? 'libros' : 'páginas';

    let message: string;

    this.logger.log(
      `Checking goal ${goal.id} progress after finish: ${expectedProgress} vs ${goal.progress}`,
    );

    if (goal.progress < 100) {
      message = `¡No te desanimes! Aunque no completaste tu meta de leer ${goal.targetAmount} ${goalType}, 
          lo importante es que sigues avanzando. Cada esfuerzo cuenta. ¡Sigue intentándolo, tú puedes lograrlo!`;
    } else {
      message = `¡Felicidades! Has completado tu meta de leer ${goal.targetAmount} ${goalType}. ¡Excelente trabajo!`;
    }
    await this.notificationsService.createNotification(
      goal.userId,
      goal.id,
      message,
    );
  }
}
