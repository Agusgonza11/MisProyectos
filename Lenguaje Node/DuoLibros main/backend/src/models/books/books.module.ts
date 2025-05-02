import { Module } from '@nestjs/common';
import { BooksController } from './books.controller';
import { PrismaService } from 'src/prisma.service';
import { BooksService } from './books.service';
import { FirebaseService } from 'src/firebase/firebase_service';
import { ReadBookModule } from '../read-book/read-book.module';
import { AuthModule } from 'src/auth/auth.module';
import { UsersModule } from '../users/users.module';

@Module({
  controllers: [BooksController],
  providers: [BooksService, PrismaService, FirebaseService],
  exports: [BooksService],
  imports: [ReadBookModule, AuthModule, UsersModule],
})
export class BooksModule {}
