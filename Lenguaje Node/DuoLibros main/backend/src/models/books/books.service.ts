import { Book, Prisma, Review, User } from '@prisma/client';
import { BookDTO } from './dto/book.dto';
import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../prisma.service';
import { FirebaseService } from 'src/firebase/firebase_service';
import { UserBookStatus } from '../read-book/enum/status';
import { BookWithStatus } from './types/book_with_status';

@Injectable()
export class BooksService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly firebaseService: FirebaseService,
  ) {}

  async create(data: BookDTO, coverImage: Express.Multer.File) {
    if (await this.exists(data.isbn)) {
      throw new BadRequestException('ISBN Duplicado');
    }
    const coverUrl = await this.firebaseService.uploadFile(
      coverImage,
      data.isbn,
    );

    return this.prisma.book.create({
      data: {
        title: data.title,
        author: data.author,
        publishedDate: data.publishedDate,
        genre: data.genre,
        description: data.description,
        isbn: data.isbn,
        coverUrl: coverUrl,
      },
    });
  }

  async findAll<T extends Prisma.BookFindManyArgs>(
    options: T,
  ): Promise<(Book & { readBy: any[] })[]> {
    const include = {
      reviews: true,
      ...options?.include,
    };

    const books = await this.prisma.book.findMany({ ...options, include });

    return books.map((book) => ({
      ...book,
      score:
        book.reviews.length > 0
          ? book.reviews.reduce((acc, curr) => acc + curr.score, 0) /
            book.reviews.length
          : 0,
    }));
  }

  findAuthorBooks(user: User): Promise<Book[]> {
    return this.findAll({
      where: {
        author: user.name + ' ' + user.lastName,
      },
    });
  }

  calculateScore(reviews: Review[]) {
    const score =
      reviews.reduce((acc, curr) => acc + curr.score, 0) / reviews.length;
    return Math.round(score * 2) / 2;
  }

  async findOne(id: number) {
    const book = await this.prisma.book.findUnique({
      where: { id },
      include: { reviews: true },
    });

    if (!book) throw new NotFoundException('Book not found');

    return {
      ...book,
      score: this.calculateScore(book.reviews),
    };
  }

  update(id: number, data: Partial<Book>): Promise<Book> {
    return this.prisma.book.update({
      where: {
        id,
      },
      data,
    });
  }

  remove(id: number): Promise<Book> {
    return this.prisma.book.delete({
      where: {
        id,
      },
    });
  }

  async getUserReadBooks(userId: number) {
    return this.prisma.readBook.findMany({
      where: { userId },
      include: {
        book: true,
      },
    });
  }

  async exists(isbn: string): Promise<boolean> {
    const count = await this.prisma.book.count({
      where: {
        isbn,
      },
    });

    return !!count;
  }

  async findByUserStatus(userId: number): Promise<BookWithStatus[]> {
    const books = await this.findAll({
      where: {
        readBy: {
          some: {
            userId,
          },
        },
      },
      include: {
        readBy: {
          where: {
            userId,
          },
        },
      },
    });

    return books.map((book) => {
      const readBy = book.readBy?.[0] || {};

      let status: UserBookStatus;
      if (readBy.finishedAt) {
        status = UserBookStatus.READ;
      } else if (readBy.startedAt) {
        status = UserBookStatus.READING;
      } else {
        status = UserBookStatus.PLAN_TO_READ;
      }

      return {
        ...book,
        status,
        readBy: book.readBy,
      };
    }) as BookWithStatus[];
  }

  searchBooks(query: string) {
    return this.findAll({
      where: {
        OR: [
          {
            title: {
              contains: query,
              mode: 'insensitive',
            },
          },
          {
            author: {
              contains: query,
              mode: 'insensitive',
            },
          },
          {
            isbn: {
              contains: query,
              mode: 'insensitive',
            },
          },
          isNaN(parseInt(query))
            ? {}
            : {
                id: {
                  equals: parseInt(query),
                },
              },
        ],
      },
    });
  }

  findFavoriteBooks(userId: number): Promise<Book[]> {
    return this.findAll({
      where: {
        favoritedBy: {
          some: {
            userId,
          },
        },
      },
    });
  }
}
