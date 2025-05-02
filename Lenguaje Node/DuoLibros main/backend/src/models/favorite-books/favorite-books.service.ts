import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma.service';
import { FavoriteBook, ReadBook } from '@prisma/client';

@Injectable()
export class FavoriteBooksService {


  constructor(private prisma: PrismaService) { }

  async removeFavoriteBook(userId: number, bookId: number): Promise<FavoriteBook> {
    return this.prisma.favoriteBook.delete({
      where: {
        userId_bookId: {
          userId,
          bookId,
        },
      }
    });
  }

  async addFavoriteBook(userId: number, bookId: number): Promise<FavoriteBook> {
    return this.prisma.favoriteBook.create({
      data: {
        userId,
        bookId,
      }
    });
  }
}
