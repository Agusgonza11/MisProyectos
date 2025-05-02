import { Controller, Post, Get, Param, Delete, Put, UseGuards } from '@nestjs/common';
import { ReadBookService } from './read-book.service';
import { AuthGuard } from 'src/auth/auth.guard';
import { ApiBearerAuth } from '@nestjs/swagger';

@Controller('read-book')
@ApiBearerAuth()
@UseGuards(AuthGuard)
export class ReadBookController {
  constructor(private readonly readBookService: ReadBookService) { }

  @Put('/plan-to-read/:userId/:bookId')
  async markAsPlanToRead(
    @Param('userId') userId: number,
    @Param('bookId') bookId: number
  ): Promise<void> {
    return this.readBookService.markAsPlanToRead(userId, bookId);
  }

  @Put('/reading/:userId/:bookId')
  async markAsReading(
    @Param('userId') userId: number,
    @Param('bookId') bookId: number
  ): Promise<void> {
    return this.readBookService.markAsReading(userId, bookId);
  }

  @Put('/read/:userId/:bookId')
  async markAsRead(
    @Param('userId') userId: number,
    @Param('bookId') bookId: number
  ): Promise<void> {
    return this.readBookService.markAsRead(userId, bookId);
  }

  @Delete(':userId/:bookId')
  removeUserReadBook(
    @Param('userId') userId: number,
    @Param('bookId') bookId: number
  ) {
    return this.readBookService.removeUserReadBook(userId, bookId);
  }
}
