import { User } from '@prisma/client';
import { PrismaService } from '../../prisma.service';
import { Injectable } from '@nestjs/common';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  create(data: Omit<User, 'id'>) {
    return this.prisma.user.create({
      data,
    });
  }

  findAll(): Promise<User[]> {
    return this.prisma.user.findMany();
  }

  findOne(id: number): Promise<User> {
    return this.prisma.user.findUnique({
      where: {
        id,
      },
    });
  }

  update(id: number, data: Partial<User>): Promise<User> {
    return this.prisma.user.update({
      where: {
        id,
      },
      data,
    });
  }

  remove(id: number): Promise<User> {
    return this.prisma.user.delete({
      where: {
        id,
      },
    });
  }

  findByUID(uid: string): Promise<User> {
    return this.prisma.user.findUnique({
      where: {
        uid,
      },
    });
  }

  findByUIDIncludeData(uid: string): Promise<User> {
    return this.prisma.user.findUnique({
      where: {
        uid,
      },
    });
  }

  async findByEmail(email: string): Promise<User> {
    const users = await this.prisma.user.findMany({
      where: {
        email,
      },
    });

    if (users.length > 1) {
      throw new Error('Multiple users found with the same email');
    }

    return users[0];
  }
}
