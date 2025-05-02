import { Module } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { ReviewsController } from './reviews.controller';
import { ReviewsService } from './reviews.service';
import { UsersModule } from '../users/users.module';

@Module({
  controllers: [ReviewsController],
  providers: [ReviewsService, PrismaService],
  exports: [],
  imports: [UsersModule]
})
export class ReviewsModule { }
