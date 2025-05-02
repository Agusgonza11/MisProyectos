import { PrismaClient } from '@prisma/client';
import { faker } from './faker_instance';

const prisma = new PrismaClient();

async function main() {
  const reviews = [];

  const reviewContentMap = {
    5: 'Great book, highly recommend!',
    4: 'Great book, highly recommend!',
    3: 'This book was okay, not my favorite.',
    2: 'I did not enjoy this book.',
    1: 'This book was pretty bad.',
    0: 'Worst book I have ever read.',
  };

  const books = await prisma.book.findMany();
  const users = await prisma.user.findMany();

  for (const book of books) {
    for (const user of users) {
      const score = faker.number.int({ min: 0, max: 5 });
      reviews.push({
        userId: user.id,
        bookId: book.id,
        content: reviewContentMap[score],
        score,
        createdAt: new Date(),
      });
    }

    for (const review of reviews) {
      await prisma.review.upsert({
        where: {
          userId_bookId: { userId: review.userId, bookId: review.bookId },
        },
        update: {
          content: review.content,
          score: review.score,
          createdAt: review.createdAt,
        },
        create: review,
      });
    }
  }
  console.log('Reviews seeded');
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
