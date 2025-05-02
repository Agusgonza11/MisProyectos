import { ApiResponseProperty } from "@nestjs/swagger";
import { Genre, ReadBook } from "@prisma/client";
import { UserBookStatus } from "src/models/read-book/enum/status";

export class BookWithStatus {
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

    @ApiResponseProperty({
        example: [{
            "id": 14,
            "userId": 1,
            "bookId": 28,
            "createdAt": "2024-11-03T03:19:39.641Z",
            "finishedAt": "2024-11-03T03:32:47.316Z",
            "startedAt": "2024-11-03T03:32:41.517Z"
        }]
    })
    readBy: ReadBook[];

    @ApiResponseProperty({ example: UserBookStatus.READ })
    status: UserBookStatus;
}