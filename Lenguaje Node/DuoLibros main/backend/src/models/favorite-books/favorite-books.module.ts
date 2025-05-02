import { Module } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { FavoriteBooksService } from './favorite-books.service';
import { FavoriteBooksController } from './favorite-books.controller';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [UsersModule],
  controllers: [FavoriteBooksController],
  providers: [FavoriteBooksService, PrismaService],
  exports: [FavoriteBooksService],
})
export class FavoriteBookModule { }
