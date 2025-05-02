import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { GroupDTO, GroupUpdateDTO } from './dto/groups.dto';

@Injectable()
export class GroupsService {
  constructor(private prisma: PrismaService) {}

  async create(data: GroupDTO, userId: number) {
    return this.prisma.group.create({
      data: {
        name: data.name,
        description: data.description,
        createdBy: userId,
        members: {
          create: {
            userId,
          },
        },
      },
    });
  }

  async getAllGroups() {
    return this.prisma.group.findMany({
      include: {
        members: true,
      },
    });
  }

  async getGroupById(groupId: number) {
    const group = await this.prisma.group.findUnique({
      where: { id: groupId },
      include: {
        members: {
          include: {
            user: true,
          },
        },
      },
    });

    if (!group) {
      throw new NotFoundException('El grupo no existe.');
    }

    return group;
  }

  async getCompletedGoalsByGroup(groupId: number) {
    const members = await this.prisma.group.findUnique({
      where: { id: groupId },
      include: {
        members: true,
      },
    });

    if (!members) {
      throw new Error('El grupo no tiene miembros.');
    }

    const completedGoals = await this.prisma.goal.findMany({
      where: {
        userId: { in: members.members.map((member) => member.userId) },
        completed: true,
        progress: 100,
      },
      include: {
        user: true,
      },
    });

    return completedGoals;
  }

  async update(groupId: number, updateData: GroupUpdateDTO) {
    const group = await this.prisma.group.findUnique({
      where: { id: groupId },
    });

    if (!group) {
      throw new NotFoundException('El grupo no existe.');
    }

    return this.prisma.group.update({
      where: { id: groupId },
      data: {
        name: updateData.name,
        description: updateData.description,
      },
    });
  }

  async delete(id: number) {
    return this.prisma.group.delete({
      where: { id },
    });
  }

  async joinGroup(groupId: number, userId: number) {
    const isMember = await this.prisma.groupMember.findUnique({
      where: {
        userId_groupId: { userId, groupId },
      },
    });

    if (isMember) {
      throw new Error('El usuario ya forma parte de este grupo.');
    }

    return this.prisma.groupMember.create({
      data: {
        userId,
        groupId,
        joinedAt: new Date(),
      },
    });
  }

  async leaveGroup(groupId: number, userId: number) {
    const isMember = await this.prisma.groupMember.findUnique({
      where: {
        userId_groupId: { userId, groupId },
      },
    });

    if (!isMember) {
      throw new NotFoundException('El usuario no forma parte de este grupo.');
    }

    return this.prisma.groupMember.delete({
      where: {
        userId_groupId: { userId, groupId },
      },
    });
  }
}
