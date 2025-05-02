import {
  Controller,
  Delete,
  Get,
  Param,
  Put,
  Req,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth } from '@nestjs/swagger';
import { AuthGuard } from 'src/auth/auth.guard';
import { User } from '@prisma/client';
import { NotificationsService } from './notifications.service';

@Controller('notifications')
@ApiBearerAuth()
@UseGuards(AuthGuard)
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  @Put(':id/view')
  markAsViewed(@Param('id') id: number) {
    return this.notificationsService.markAsViewed(id);
  }

  @Get()
  getUserNotifications(@Req() req: Request & { user: User }) {
    return this.notificationsService.getUserNotifications(req.user.id);
  }

  @Delete(':id')
  deleteGoal(@Param('id') id: number) {
    return this.notificationsService.delete(id);
  }
}
