import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  UseGuards
} from '@nestjs/common';
import { ReviewsService } from './reviews.service';
import { ReviewDTO } from './dto/review.dto';
import { ReviewResponse } from './dto/review.response';
import { AuthGuard } from 'src/auth/auth.guard';
import { ApiBearerAuth } from '@nestjs/swagger';

@Controller('reviews')
@ApiBearerAuth()
@UseGuards(AuthGuard)
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) { }

  @Get(':bookId')
  async getReviewsByBook(@Param('bookId') bookId: number): Promise<ReviewResponse[]> {
    return this.reviewsService.getReviewsByBook(bookId);
  }

  @Get(':bookId/:userId')
  async getReviewsByBookAndUserId(
    @Param('bookId') bookId: number,
    @Param('userId') userId: number,
  ): Promise<ReviewResponse[]> {
    return this.reviewsService.getReviewsByBookAndUser(bookId, userId);
  }

  @Post()
  async createReview(@Body() reviewData: ReviewDTO) {
    return this.reviewsService.create(reviewData);
  }

  @Put(':id')
  updateReview(@Param('id') id: number, @Body() reviewData: ReviewDTO) {
    return this.reviewsService.update(id, reviewData);
  }

  @Delete(':id')
  deleteReview(@Param('id') id: number) {
    return this.reviewsService.delete(id);
  }
}
