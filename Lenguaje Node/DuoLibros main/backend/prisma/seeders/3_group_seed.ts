import { PrismaClient } from '@prisma/client';
import { faker } from './faker_instance';

const prisma = new PrismaClient();

async function main() {
  const groupNames = [
    {
      name: 'Eruditos de las Letras',
      description:
        'Inspirado en la facción "Erudición" de La saga Divergente, este club de lectura es perfecto para aquellos que buscan conocimiento en cada página. Los miembros exploran libros que invitan a la reflexión, desentrañan simbolismos y comparten teorías, honrando el espíritu curioso y analítico que define a los eruditos. Aquí, la lectura no es solo un pasatiempo, sino una herramienta para aprender y crecer con cada capítulo.',
    },
    {
      name: 'El Club de los Merodeadores',
      description:
        'Inspirado en los legendarios merodeadores de Harry Potter, este club reúne a los amantes de la magia, la amistad y las aventuras. Los miembros exploran historias fantásticas, debaten teorías mágicas y descubren su "marauder" interno mientras recorren las páginas de mundos llenos de maravillas. Porque en este club, como en el mapa del merodeador, siempre hay un nuevo territorio literario por descubrir. ¡Juro solemnemente que mis intenciones son leer mucho!',
    },
    {
      name: 'Los Guardianes de los Anillos',
      description:
        'Este club está inspirado en El Señor de los Anillos y en la noble misión de la Comunidad del Anillo. Los lectores, como guardianes de las grandes historias, se embarcan en un viaje literario para explorar tierras de fantasía, compartir aventuras y proteger los relatos más valiosos del olvido. Cada libro es un anillo que conecta mundos, y este club se asegura de que esas historias permanezcan siempre vivas.',
    },
    {
      name: 'Los Tributos de la Lectura',
      description:
        'Inspirado en los valientes tributos de Los Juegos del Hambre, este club es para aquellos que aceptan el desafío de leer historias llenas de intensidad y emoción. Aquí, los miembros se sumergen en libros que despiertan pasiones, debaten las luchas de los personajes y reflexionan sobre las lecciones ocultas en las páginas. Al igual que en Panem, solo los más intrépidos se adentran en este "arena" de letras. ¡Que la suerte esté siempre de su lado!',
    },
  ];
  const users = await prisma.user.findMany();

  for (let i = 0; i < groupNames.length; i++) {
    const creator = faker.helpers.arrayElement(users).id;
    const data = {
      name: groupNames[i].name,
      description: groupNames[i].description,
      createdBy: creator,
    };
    const group = await prisma.group.upsert({
      create: data,
      update: data,
      where: {
        name: groupNames[i].name,
      },
    });

    for (let i = 1; i < 4; i++) {
      const member = faker.helpers.arrayElement(users).id;
      await prisma.groupMember.upsert({
        create: {
          userId: member,
          groupId: group.id,
        },
        update: {
          userId: member,
          groupId: group.id,
        },
        where: {
          userId_groupId: {
            userId: member,
            groupId: group.id,
          },
        },
      });
    }
  }

  console.log('Groups seeded');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
