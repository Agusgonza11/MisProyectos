import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma.service';
import { ReadBook } from '@prisma/client';
import { UserBookStatus } from './enum/status';

@Injectable()
export class ReadBookService {

  constructor(private prisma: PrismaService) { }

  markAsPlanToRead(userId: number, bookId: number): Promise<void> {
    return this.markAs(userId, bookId, UserBookStatus.PLAN_TO_READ);
  }

  markAsReading(userId: number, bookId: number): Promise<void> {
    return this.markAs(userId, bookId, UserBookStatus.READING);
  }

  markAsRead(userId: number, bookId: number): Promise<void> {
    return this.markAs(userId, bookId, UserBookStatus.READ);
  }

  async markAs(userId: number, bookId: number, status: UserBookStatus): Promise<void> {
    let readBook = await this.prisma.readBook.findUnique({
      where: {
        userId_bookId: {
          userId,
          bookId,
        },
      },
    });

    if (!readBook) {
      readBook = await this.prisma.readBook.create({
        data: {
          userId,
          bookId,
        },
      });
    }

    const fields = {};

    if (status === UserBookStatus.PLAN_TO_READ) {
      fields['startedAt'] = null;
      fields['finishedAt'] = null;
    } else if (status === UserBookStatus.READ) {
      fields['finishedAt'] = new Date();
    } else if (status === UserBookStatus.READING) {
      fields['startedAt'] = new Date();
      fields['finishedAt'] = null;
    }

    await this.prisma.readBook.update({
      where: {
        id: readBook.id,
      },
      data: fields
    });
  }

  async getReadBooksByUser(userId: number): Promise<ReadBook[]> {
    return this.prisma.readBook.findMany({
      where: { userId },
      include: { book: true }
    });
  }

  async hasUserReadBook(userId: number, bookId: number): Promise<boolean> {
    const readBook = await this.prisma.readBook.findUnique({
      where: {
        userId_bookId: {
          userId,
          bookId,
        },
      },
    });

    return !!readBook;
  }

  async removeUserReadBook(userId: number, bookId: number) {
    return this.prisma.readBook.deleteMany({
      where: {
        userId,
        bookId
      }
    });
  }
}
