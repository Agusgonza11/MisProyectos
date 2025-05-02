import { PrismaClient } from '@prisma/client';
import { books } from './books';

const prisma = new PrismaClient();

async function main() {
  for (const book of books) {
    await prisma.book.upsert({
      where: { isbn: book.isbn },
      update: {
        isbn: book.isbn,
        title: book.title,
        author: book.author,
        publishedDate: book.publishedDate,
        description: book.description,
        coverUrl: book.coverUrl,
        genre: book.genre,
      },
      create: book,
    });
  }

  console.log('Books seeded');
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
