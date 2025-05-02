import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma.service';
import { ReviewDTO } from './dto/review.dto';

@Injectable()
export class ReviewsService {

  constructor(private readonly prisma: PrismaService) { }

  async create(data: ReviewDTO) {
    return this.prisma.review.create({
      data: {
        content: data.content,
        userId: data.userId,
        bookId: data.bookId,
        score: data.score
      },
    });
  }

  async getReviewsByBook(bookId: number) {
    return this.prisma.review.findMany({
      where: { bookId },
      include: {
        user: true,
        book: true
      },
      orderBy: {
        createdAt: 'desc'
      }
    });
  }

  async getReviewsByBookAndUser(bookId: number, userId: number) {
    return this.prisma.review.findMany({
      where: {
        bookId,
        userId
      },
      include: {
        user: true,
        book: true
      }
    });
  }

  update(id: number, reviewData: ReviewDTO) {
    return this.prisma.review.update({
      where: { id },
      data: {
        content: reviewData.content,
        score: reviewData.score,
        userId: reviewData.userId,
        bookId: reviewData.bookId
      }
    });
  }

  delete(id: number) {
    return this.prisma.review.delete({
      where: { id }
    });
  }
}