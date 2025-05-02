import { PrismaClient } from '@prisma/client';
import { faker } from './faker_instance';

const prisma = new PrismaClient();

async function main() {
  const users = await prisma.user.findMany();

  const books = await prisma.book.findMany();
  for (const user of users) {
    for (let i = 1; i <= 5; i++) {
      const bookId = faker.helpers.arrayElement(books).id;
      await prisma.favoriteBook.upsert({
        where: {
          userId_bookId: { userId: user.id, bookId },
        },
        update: {},
        create: {
          userId: user.id,
          bookId,
        },
      });
    }
  }

  console.log('Favorite books seeded');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
