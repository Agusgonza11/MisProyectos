import { Genre, Book, ReadBook } from '@prisma/client';
import { Type } from 'class-transformer';
import { IsDateString, IsEnum, IsNotEmpty, IsOptional, IsString, ValidateNested } from 'class-validator';
import { ReadBookDTO } from 'src/models/read-book/dto/read-book.dto';
import { UserBookStatus } from 'src/models/read-book/enum/status';

export class BookDTO {
  @IsNotEmpty()
  title: string;

  @IsOptional()
  author: string;

  @IsNotEmpty()
  @IsDateString()
  publishedDate: Date;

  @IsEnum(Genre, {
    message: 'Genero tiene que ser valido'
  })
  genre: Genre;

  @IsOptional()
  description: string;

  @IsOptional()
  @ValidateNested({ each: true })
  @Type(() => ReadBookDTO)
  readByUsers?: ReadBookDTO[];

  @IsString()
  @IsNotEmpty()
  isbn: string;
}