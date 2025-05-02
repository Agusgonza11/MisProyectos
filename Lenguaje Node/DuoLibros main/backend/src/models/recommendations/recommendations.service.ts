import { Injectable } from '@nestjs/common';
import { Genre } from '@prisma/client';
import { PrismaService } from 'src/prisma.service';

@Injectable()
export class RecommendationsService {
  constructor(private readonly prisma: PrismaService) {}

  async getBookRecommendations(userId: number) {
    // Paso 1: Obtener los libros favoritos del usuario con sus géneros
    const favoriteBooks = await this.prisma.book.findMany({
      where: {
        favoritedBy: { some: { userId } },
      },
      select: {
        genre: true,
      },
    });

    // Paso 2: Contar los géneros más frecuentes
    const genreCounts: Record<string, number> = {};
    favoriteBooks.forEach((book) => {
      genreCounts[book.genre] = (genreCounts[book.genre] || 0) + 1;
    });

    // Ordenar los géneros por frecuencia
    const sortedGenres = Object.entries(genreCounts)
      .sort(([, countA], [, countB]) => countB - countA)
      .map(([genre]) => genre);

    // Paso 3: Seleccionar los dos géneros principales
    let selectedGenres: Genre[];
    if (sortedGenres.length >= 2) {
      selectedGenres = sortedGenres.slice(0, 2) as Genre[];
    } else if (sortedGenres.length === 1) {
      selectedGenres = [sortedGenres[0]] as Genre[];
    } else {
      selectedGenres = [];
    }

    // Paso 4: Obtener libros recomendados en los géneros seleccionados
    const recommendedBooks = await this.prisma.book.findMany({
      where: {
        AND: [
          { genre: { in: selectedGenres } },
          { NOT: { favoritedBy: { some: { userId } } } },
          { NOT: { readBy: { some: { userId } } } },
        ],
      },
      include: {
        reviews: true,
      },
    });

    // Paso 5: Calcular promedio de ratings y ordenar
    const booksWithRatings = recommendedBooks.map((book) => {
      const averageRating =
        book.reviews.reduce((sum, review) => sum + review.score, 0) /
          book.reviews.length || 0;

      return {
        id: book.id,
        title: book.title,
        author: book.author,
        genre: book.genre,
        description: book.description,
        coverUrl: book.coverUrl,
        averageRating,
      };
    });

    // Ordenar por promedio de ratings en orden descendente
    const topRatedBooks = booksWithRatings
      .sort((a, b) => b.averageRating - a.averageRating)
      .slice(0, 5);

    return topRatedBooks;
  }
}
