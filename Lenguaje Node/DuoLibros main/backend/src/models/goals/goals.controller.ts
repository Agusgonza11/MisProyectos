import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Put,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth } from '@nestjs/swagger';
import { AuthGuard } from 'src/auth/auth.guard';
import { User } from '@prisma/client';
import { GoalsService } from './goals.service';
import { GoalDTO, GoalUpdateDTO } from './dto/goals.dto';

@Controller('goals')
@ApiBearerAuth()
@UseGuards(AuthGuard)
export class GoalsController {
  constructor(private readonly goalsService: GoalsService) {}

  @Post()
  createGoal(@Body() goalData: GoalDTO, @Req() req: Request & { user: User }) {
    return this.goalsService.create(req.user.id, goalData);
  }

  @Put(':id')
  updateGoalProgress(
    @Param('id') id: number,
    @Body() updateData: GoalUpdateDTO,
  ) {
    return this.goalsService.updateGoalProgress(id, updateData);
  }

  @Get()
  getUserGoals(@Req() req: Request & { user: User }) {
    return this.goalsService.getUserGoals(req.user.id);
  }

  @Delete(':id')
  deleteGoal(@Param('id') id: number) {
    return this.goalsService.delete(id);
  }
}
