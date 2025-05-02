import {
  Controller,
  Param,
  Post,
  Get,
  Body,
  Delete,
  Put,
  UseInterceptors,
  UploadedFile,
  BadRequestException,
  Req,
  Query,
  UseGuards,
} from '@nestjs/common';
import { BooksService } from './books.service';
import { BookDTO } from './dto/book.dto';
import { FileInterceptor } from '@nestjs/platform-express';
import { User } from '@prisma/client';
import { BookWithStatus } from './types/book_with_status';
import { BookResponse } from './types/book_response';
import { ApiBearerAuth } from '@nestjs/swagger';
import { AuthGuard } from '../../auth/auth.guard';

@Controller('books')
@ApiBearerAuth()
@UseGuards(AuthGuard)
export class BooksController {
  constructor(private readonly booksService: BooksService) {}

  @Get('/author')
  getAuthorBooks(@Req() req: Request & { user: User }) {
    return this.booksService.findAuthorBooks(req.user);
  }

  @Get('/search')
  searchBooks(@Query('query') query: string): Promise<BookResponse[]> {
    return this.booksService.searchBooks(query);
  }

  @Get('/status')
  getBooksStatusByUserId(
    @Query('userId') userId: number,
  ): Promise<BookWithStatus[]> {
    return this.booksService.findByUserStatus(userId);
  }

  @Get('/favorite')
  getFavoriteBooksByUserId(
    @Query('userId') userId: number,
  ): Promise<BookResponse[]> {
    return this.booksService.findFavoriteBooks(userId);
  }

  @Get('/:id')
  getBookDetail(@Param('id') id: string) {
    return this.booksService.findOne(+id);
  }

  @Get()
  getBooks() {
    return this.booksService.findAll({});
  }

  @Post()
  @UseInterceptors(
    FileInterceptor('coverImage', {
      limits: {
        fileSize: 5 * 1024 * 1024, // 5MB
      },
      fileFilter: (_, file, callback) => {
        const allowedMimeTypes = ['image/jpeg', 'image/png', 'image/jpg'];
        if (!allowedMimeTypes.includes(file.mimetype)) {
          return callback(
            new BadRequestException('Tipo de archivo invalido'),
            false,
          );
        }
        callback(null, true);
      },
    }),
  )
  async createBook(
    @UploadedFile() file: Express.Multer.File,
    @Body() bookData: BookDTO,
    @Req() req: Request & { user: User },
  ) {
    if (!file) {
      throw new BadRequestException('Se debe proporcionar una imagen');
    }

    bookData.author = req.user.name + ' ' + req.user.lastName;

    return this.booksService.create(bookData, file);
  }

  @Put(':id')
  updateBook(@Param('id') id: number, @Body() book) {
    return this.booksService.update(id, book);
  }

  @Delete(':id')
  removeBook(@Param('id') id: number) {
    return this.booksService.remove(id);
  }
}
