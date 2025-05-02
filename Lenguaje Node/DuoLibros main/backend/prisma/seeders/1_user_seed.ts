import { PrismaClient } from '@prisma/client';
import { users } from './users';

const prisma = new PrismaClient();

async function main() {
  for (const user of users) {
    await prisma.user.upsert({
      where: { uid: user.uid },
      update: {
        name: user.name,
        lastName: user.lastName,
        email: user.email,
      },
      create: user,
    });
  }

  console.log('Users seeded');
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
