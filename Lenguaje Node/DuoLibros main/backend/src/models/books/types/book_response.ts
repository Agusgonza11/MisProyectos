import { ApiResponseProperty } from "@nestjs/swagger";
import { Genre, ReadBook } from "@prisma/client";
import { UserBookStatus } from "src/models/read-book/enum/status";

export class BookResponse {
    @ApiResponseProperty({ example: 1 })
    id: number;

    @ApiResponseProperty({ example: "The Great Gatsby" })
    title: string;

    @ApiResponseProperty({ example: "978-3-16-148410-0" })
    isbn: string;

    @ApiResponseProperty({ example: "F. Scott Fitzgerald" })
    author: string;

    @ApiResponseProperty({ example: "1925-04-10T00:00:00.000Z" })
    publishedDate: Date;

    @ApiResponseProperty({ example: "Fiction" })
    genre: Genre;

    @ApiResponseProperty({ example: "A novel set in the Roaring Twenties." })
    description: string;

    @ApiResponseProperty({ example: "https://example.com/cover.jpg" })
    coverUrl: string;
}