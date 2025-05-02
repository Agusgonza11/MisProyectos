import { Module } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { ReadBookController } from './read-book.controller';
import { ReadBookService } from './read-book.service';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [UsersModule],
  controllers: [ReadBookController],
  providers: [ReadBookService, PrismaService],
  exports: [ReadBookService],
})
export class ReadBookModule { }
