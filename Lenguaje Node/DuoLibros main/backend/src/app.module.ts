import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
import { UsersModule } from './models/users/users.module';
import { AuthModule } from './auth/auth.module';
import { BooksModule } from './models/books/books.module';
import { ReadBookModule } from './models/read-book/read-book.module';
import { ReviewsModule } from './models/reviews/reviews.module';
import { FavoriteBookModule } from './models/favorite-books/favorite-books.module';
import { GoalsModule } from './models/goals/goals.module';
import { NotificationsModule } from './models/notifications/notifications.module';
import { GroupsModule } from './models/groups/groups.module';
import { ScheduleModule } from '@nestjs/schedule';
import { CronModule } from './cron/cron.module';
import { RecommendationsModule } from './models/recommendations/recommendations.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    UsersModule,
    AuthModule,
    BooksModule,
    GoalsModule,
    ReadBookModule,
    ReviewsModule,
    FavoriteBookModule,
    NotificationsModule,
    RecommendationsModule,
    GroupsModule,
    ScheduleModule.forRoot(),
    CronModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
