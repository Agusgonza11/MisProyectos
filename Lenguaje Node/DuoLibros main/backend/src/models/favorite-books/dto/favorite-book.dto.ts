import { IsNotEmpty } from 'class-validator';

export class FavoriteBookDTO {
  @IsNotEmpty()
  userId: number;

  @IsNotEmpty()
  bookId: number;
}
