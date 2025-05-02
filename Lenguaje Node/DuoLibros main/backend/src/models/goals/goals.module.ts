import { Module } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { UsersModule } from '../users/users.module';
import { GoalsController } from './goals.controller';
import { GoalsService } from './goals.service';
import { NotificationsService } from '../notifications/notifications.service';
import { CronModule } from '../../cron/cron.module';

@Module({
  controllers: [GoalsController],
  providers: [GoalsService, PrismaService, NotificationsService],
  exports: [],
  imports: [UsersModule, CronModule],
})
export class GoalsModule {}
