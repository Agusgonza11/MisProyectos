import {
  IsDateString,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';

export class ReviewDTO {
  @IsString()
  @IsOptional()
  content: string;

  @IsNumber()
  @IsNotEmpty({ message: 'La valoracion es obligatoria' })
  score: number;

  @IsNotEmpty({ message: 'El ID del usuario es obligatorio.' })
  userId: number;

  @IsNotEmpty({ message: 'El ID del libro es obligatorio.' })
  bookId: number;

}