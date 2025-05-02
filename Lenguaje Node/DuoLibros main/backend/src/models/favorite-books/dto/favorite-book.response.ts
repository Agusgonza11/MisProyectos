import { ApiResponseProperty } from '@nestjs/swagger';
import { Book, User } from '@prisma/client';

export class FavoriteBookResponse {
  @ApiResponseProperty({ example: 1 })
  id: number;

  @ApiResponseProperty({ example: 1 })
  userId: number;

  @ApiResponseProperty({ example: 1 })
  bookId: number;
}
