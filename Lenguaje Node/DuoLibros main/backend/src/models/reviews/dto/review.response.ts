import { ApiResponseProperty } from '@nestjs/swagger';
import { Book, User } from '@prisma/client';

export class ReviewResponse {
    @ApiResponseProperty({ example: 1 })
    id: number;

    @ApiResponseProperty({ example: 'This is a great book!' })
    content: string;

    @ApiResponseProperty({ example: 2 })
    score: number;

    @ApiResponseProperty({ example: '2023-10-01T00:00:00.000Z' })
    createdAt: Date;

    @ApiResponseProperty({ example: 1 })
    userId: number;

    @ApiResponseProperty({ example: 1 })
    bookId: number;

    @ApiResponseProperty({
        example: {
            "id": 28,
            "isbn": "9780385534260",
            "title": "The Wager: A Tale of Shipwreck, Mutiny and Murder",
            "author": "David Grann",
            "publishedDate": "2023-04-18T03:00:00.000Z",
            "description": "The riveting story of a British shipwreck in the 18th century that led to a harrowing fight for survival, a mutiny, and a trial upon the survivors' return, revealing the limits of human endurance.",
            "coverUrl": "https:\/\/storage.googleapis.com\/duolibros-32a86.appspot.com\/book-covers%2F1730329152012_9780385534260",
            "genre": "FICTION"
        }
    })
    book: Book;

    @ApiResponseProperty({
        example: {
            "id": 1,
            "uid": "uid",
            "name": "admin",
            "lastName": "admin",
            "email": "admin@gmail.com"
        }
    })
    user: User;
}
