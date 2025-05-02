import { IsNotEmpty } from 'class-validator';

export class ReadBookDTO {
  @IsNotEmpty()
  userId: number;

  @IsNotEmpty()
  bookId: number;

  readAt: Date;
}
