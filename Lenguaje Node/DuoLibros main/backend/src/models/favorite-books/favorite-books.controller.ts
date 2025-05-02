import { Controller, Post, Get, Param, Delete, Put, Body, Query, UseGuards } from '@nestjs/common';
import { FavoriteBooksService } from './favorite-books.service';
import { FavoriteBookDTO } from './dto/favorite-book.dto';
import { FavoriteBookResponse } from './dto/favorite-book.response';
import { ApiBearerAuth } from '@nestjs/swagger';
import { AuthGuard } from 'src/auth/auth.guard';

@Controller('favorite-books')
@ApiBearerAuth()
@UseGuards(AuthGuard)
export class FavoriteBooksController {
  constructor(private readonly favoriteBooksService: FavoriteBooksService) { }

  @Delete()
  removeFavoriteBook(
    @Query('userId') userId: number,
    @Query('bookId') bookId: number
  ): Promise<FavoriteBookResponse> {
    return this.favoriteBooksService.removeFavoriteBook(userId, bookId);
  }

  @Post()
  async addFavoriteBook(
    @Body() data: FavoriteBookDTO
  ): Promise<FavoriteBookResponse> {
    return this.favoriteBooksService.addFavoriteBook(data.userId, data.bookId);
  }
}
