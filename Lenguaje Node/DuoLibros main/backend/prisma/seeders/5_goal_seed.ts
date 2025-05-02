import { GoalType, PrismaClient } from '@prisma/client';
import { faker } from './faker_instance';

const prisma = new PrismaClient();

function getQuartile() {
  const randomNum = Math.random();
  if (randomNum < 0.25) return 0;
  if (randomNum < 0.5) return 1;
  if (randomNum < 0.75) return 2;
  return 3;
}

async function createCompletedGoals(user) {
  const quartile = getQuartile();
  for (let i = 0; i < quartile; i++) {
    const startDate = faker.date.between({
      from: '2023-01-01',
      to: '2023-06-30',
    });
    const endDate = faker.date.between({ from: startDate, to: '2023-12-31' });
    const progress = 100;

    const randomGoalType = faker.helpers.arrayElement([
      GoalType.BOOKS,
      GoalType.PAGES,
    ]);
    const data = {
      userId: user.id,
      type: randomGoalType,
      targetAmount: 100,
      amountRead: 100,
      progress: progress,
      startDate: startDate,
      endDate: endDate,
      completed: true,
      allowNotifications: faker.datatype.boolean(),
      notificationTimeHour: faker.number.int({ min: 0, max: 23 }),
      notificationTimeMinutes: faker.number.int({ min: 0, max: 59 }),
      createdAt: startDate,
    };

    await prisma.goal.upsert({
      where: {
        userId_type_createdAt: {
          userId: user.id,
          type: randomGoalType,
          createdAt: startDate,
        },
      },
      update: data,
      create: data,
    });
  }
}

async function main() {
  const users = await prisma.user.findMany();

  for (const user of users) {
    for (let i = 0; i < 2; i++) {
      const startDate = faker.date.between({
        from: '2023-01-01',
        to: '2023-06-30',
      });
      const endDate = faker.date.between({ from: startDate, to: '2023-12-31' });
      const progress = faker.number.int({ min: 0, max: 100 });

      const randomGoalType = faker.helpers.arrayElement([
        GoalType.BOOKS,
        GoalType.PAGES,
      ]);
      const data = {
        userId: user.id,
        type: randomGoalType,
        targetAmount: 100,
        amountRead: faker.number.int({ min: 0, max: 80 }),
        progress: progress,
        startDate: startDate,
        endDate: endDate,
        completed: true,
        allowNotifications: faker.datatype.boolean(),
        notificationTimeHour: faker.number.int({ min: 0, max: 23 }),
        notificationTimeMinutes: faker.number.int({ min: 0, max: 59 }),
        createdAt: startDate,
      };

      if (i == 2) {
        data.progress = 100;
        data.amountRead = 100;
      }
      await prisma.goal.upsert({
        where: {
          userId_type_createdAt: {
            userId: user.id,
            type: randomGoalType,
            createdAt: startDate,
          },
        },
        update: data,
        create: data,
      });
    }

    const currentGoal = {
      userId: user.id,
      type: GoalType.BOOKS,
      targetAmount: 50,
      amountRead: 0,
      progress: 0,
      startDate: new Date(),
      endDate: new Date(new Date().setFullYear(new Date().getFullYear() + 1)),
      completed: false,
      allowNotifications: true,
      notificationTimeHour: 9,
      notificationTimeMinutes: 0,
      createdAt: new Date(),
    };

    await prisma.goal.upsert({
      where: {
        userId_type_createdAt: {
          userId: user.id,
          type: GoalType.BOOKS,
          createdAt: currentGoal.createdAt,
        },
      },
      update: currentGoal,
      create: currentGoal,
    });

    createCompletedGoals(user);
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
