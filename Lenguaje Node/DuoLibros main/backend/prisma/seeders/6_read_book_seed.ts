import { PrismaClient, ReadBook } from '@prisma/client';
import { faker } from './faker_instance';

const prisma = new PrismaClient();

async function main() {
  const users = await prisma.user.findMany();
  const books = await prisma.book.findMany();

  const readBooks = [];

  for (const user of users) {
    for (let i = 1; i <= 5; i++) {
      const bookId = faker.helpers.arrayElement(books).id;

      const data: Omit<ReadBook, 'id'> = {
        userId: user.id,
        bookId,
        createdAt: new Date(),
        startedAt: null,
        finishedAt: null,
      };

      const status = faker.helpers.arrayElement([
        'READING',
        'READ',
        'PLAN_TO_READ',
      ]);

      if (status === 'READ') {
        data.startedAt = faker.date.between({
          from: new Date(2020, 1, 1),
          to: new Date(),
        });
        data.finishedAt = new Date();
      } else if (status === 'READING') {
        data.startedAt = new Date();
      }

      readBooks.push(data);
    }
  }

  for (const readBook of readBooks) {
    await prisma.readBook.upsert({
      where: {
        userId_bookId: {
          userId: readBook.userId,
          bookId: readBook.bookId,
        },
      },
      update: readBook,
      create: readBook,
    });
  }

  console.log('Read book seeded');
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
