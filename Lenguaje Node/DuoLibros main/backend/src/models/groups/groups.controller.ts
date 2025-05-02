import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  Req,
  UseGuards,
} from '@nestjs/common';
import { AuthGuard } from 'src/auth/auth.guard';
import { ApiBearerAuth } from '@nestjs/swagger';
import { User } from '@prisma/client';
import { GroupsService } from './groups.service';
import { GroupDTO, GroupUpdateDTO } from './dto/groups.dto';

@Controller('groups')
@ApiBearerAuth()
@UseGuards(AuthGuard)
export class GroupsController {
  constructor(private readonly groupsService: GroupsService) {}

  @Get()
  async getAllGroups() {
    return this.groupsService.getAllGroups();
  }

  @Get(':id')
  async getGroupById(@Param('id') groupId: number) {
    return this.groupsService.getGroupById(groupId);
  }

  @Get(':groupId/completed-goals')
  async getCompletedGoalsByGroup(@Param('groupId') groupId: number) {
    return this.groupsService.getCompletedGoalsByGroup(groupId);
  }

  @Post()
  async createGroup(
    @Body() groupData: GroupDTO,
    @Req() req: Request & { user: User },
  ) {
    return this.groupsService.create(groupData, req.user.id);
  }

  @Post(':id/join')
  async joinGroup(
    @Param('id') groupId: number,
    @Req() req: Request & { user: User },
  ) {
    return this.groupsService.joinGroup(groupId, req.user.id);
  }

  @Put(':id')
  updateGroup(@Param('id') id: number, @Body() groupData: GroupUpdateDTO) {
    return this.groupsService.update(id, groupData);
  }

  @Delete(':id')
  async deleteGroup(@Param('id') groupId: number) {
    return this.groupsService.delete(groupId);
  }

  @Put(':id/leave')
  async leaveGroup(
    @Param('id') groupId: number,
    @Req() req: Request & { user: User },
  ) {
    return this.groupsService.leaveGroup(groupId, req.user.id);
  }
}
