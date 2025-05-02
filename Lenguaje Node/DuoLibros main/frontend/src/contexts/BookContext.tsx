import React, { createContext, useState, useContext, ReactNode } from "react";
import useApiService from "../services/apiService";
import { SnackbarContext } from "./SnackbarContext";
import { UserEntity } from "../models/UserEntity";
import { Genre } from "../components/Books/utils";

export enum BookStatus {
  PlanToRead = "PLAN_TO_READ",
  Reading = "READING",
  Read = "READ",
  ChooseStatus = "CHOOSE_STATUS",
}

export type BookData = {
  id: number;
  isbn: number;
  title: string;
  author: string;
  publishedDate: string;
  genre: string;
  description: string;
  readBy: ReadBook[];
  coverUrl: string;
  status: BookStatus;
  score: number;
};

export type ReadBook = {
  id: number;
  userId: number;
  bookId: number;
  user: UserEntity;
  book: BookData;
  readAt: Date;
};

export type BookDetail = BookData & {
  description: string;
  publishedDate: string;
};

export type BookContextType = {
  books: BookData[];
  selectedBook: BookDetail | null;
  getBooks: () => void;
  getAllBooks: (userId: number) => void;
  getReadBooks: (userId: number) => void;
  getBookDetail: (bookId: number) => void;
  markBookAsPlanToRead: (userId: number, bookId: number) => void;
  markBookAsReading: (userId: number, bookId: number) => void;
  markBookAsRead: (userId: number, bookId: number) => void;
  deleteBook: (userId: number, bookId: number) => void;
  getAuthorBooks: () => void;
  getFavoriteBooks: (userId: number) => void;
  markBookAsFavourite: (userId: number, bookId: number) => void;
  deleteBookAsFavourite: (userId: number, bookId: number) => void;
  getRecommendedBooks: () => void;
};

export const BookContext = createContext<BookContextType>({
  books: [],
  selectedBook: null,
  getBooks: () => {},
  getAllBooks: () => {},
  getReadBooks: () => {},
  getBookDetail: () => {},
  markBookAsPlanToRead: () => {},
  markBookAsReading: () => {},
  markBookAsRead: () => {},
  deleteBook: () => {},
  getAuthorBooks: () => {},
  getFavoriteBooks: () => {},
  markBookAsFavourite: () => {},
  deleteBookAsFavourite: () => {},
  getRecommendedBooks: () => {},
});

type BookProviderProps = {
  children: ReactNode;
};

export const BookProvider: React.FC<BookProviderProps> = ({ children }) => {
  const { showSnackbar } = useContext(SnackbarContext);
  const {
    getBooks,
    getReadBooks,
    getBookDetail,
    markAsPlanToRead,
    markAsReading,
    markAsRead,
    deleteBookFromLibrary,
    getAuthorBooksAPI,
    markAsFavourite,
    getFavouriteBooks,
    deleteBookAsFavourite,
    getRecommendedBooks,
  } = useApiService();

  const [books, setBooks] = useState<BookData[]>([]);
  const [selectedBook, setSelectedBook] = useState<BookDetail | null>(null);

  const fetchBooks = async () => {
    try {
      const response = await getBooks();
      if (response) setBooks(response);
    } catch (error) {
      console.error("Error fetching books:", error);
      showSnackbar("Error al obtener los libros", "error");
    }
  };

  const fetchBooksByStatus = async (userId: number) => {
    try {
      const response = await getReadBooks(userId);
      if (response) {
        setBooks(response);
      }
    } catch (error) {
      console.error("Error fetching books by status:", error);
      showSnackbar("Error al obtener los libros por estado", "error");
    }
  };

  const fetchBookDetailBy = async (bookId: number) => {
    try {
      const response = await getBookDetail(bookId.toString());
      if (response) setSelectedBook(response);
    } catch (error) {
      console.error("Error fetching book details:", error);
      showSnackbar("Error al obtener los detalles del libro", "error");
    }
  };

  const markBookAsPlanToRead = async (userId: number, bookId: number) => {
    try {
      const response = await markAsPlanToRead(userId, bookId);
      if (response) {
        showSnackbar("Libro marcado como plan para leer", "success");
        setBooks(response);
      }
      fetchBooksByStatus(userId);
    } catch (error) {
      console.error("Error marking book as plan to read:", error);
      showSnackbar("Error al marcar el libro como plan para leer", "error");
    }
  };

  const markBookAsReading = async (userId: number, bookId: number) => {
    try {
      const response = await markAsReading(userId, bookId);
      if (response) {
        showSnackbar("Libro marcado como leyendo", "success");
      }

      fetchBooksByStatus(userId);
    } catch (error) {
      console.error("Error marking book as reading:", error);
      showSnackbar("Error al marcar el libro como leyendo", "error");
    }
  };

  const markBookAsRead = async (userId: number, bookId: number) => {
    try {
      const response = await markAsRead(userId, bookId);
      if (response) {
        showSnackbar("Libro marcado como leído", "success");
        setBooks(response);
      }
      fetchBooksByStatus(userId);
    } catch (error) {
      console.error("Error marking book as read:", error);
      showSnackbar("Error al marcar el libro como leído", "error");
    }
  };

  const deleteBook = async (userId: number, bookId: number) => {
    try {
      const response = await deleteBookFromLibrary(userId, bookId);
      if (response) {
        showSnackbar("Libro eliminado de la biblioteca", "success");
      }
      fetchBooksByStatus(userId);
    } catch (error) {
      console.error("Error deleting book:", error);
      showSnackbar("Error al eliminar el libro", "error");
    }
  };

  const getAuthorBooks = async () => {
    try {
      const response = await getAuthorBooksAPI();
      if (response) setBooks(response);
    } catch (error) {
      console.error("Error getting author books:", error);
      showSnackbar("Error al obtener los libros del autor", "error");
    }
  };

  const getAllBooks = async (userId: number) => {
    try {
      const response = await getReadBooks(userId);
      console.log("GET ALL BOOKS", response);
      if (response) {
        setBooks(response);
      }
    } catch (error) {
      console.error("Error fetching books:", error);
      showSnackbar("Error al obtener los libros", "error");
    }
  };

  const fetchFavoriteBooks = async (userId: number) => {
    try {
      const response = await getFavouriteBooks(userId);
      if (response) {
        setBooks(response);
      }
    } catch (error) {
      console.error("Error fetching books:", error);
      showSnackbar("Error al obtener los libros", "error");
    }
  };

  const fetchRecommendedBooks = async () => {
    try {
      const response = await getRecommendedBooks();
      if (response) {
        setBooks(response);
      }
    } catch (error) {
      console.error("Error fetching books:", error);
      showSnackbar("Error al obtener los libros", "error");
    }
  };

  const markBookAsFavouriteGiven = async (userId: number, bookId: number) => {
    try {
      const response = await markAsFavourite(userId, bookId);
      if (response) {
        showSnackbar("Libro marcado como favorito", "success");
      }
    } catch (error) {
      console.error("Error marking book as favourite:", error);
      showSnackbar("Error al marcar el libro como favorito", "error");
    }
  };

  const unmarkBookAsFavouriteGiven = async (userId: number, bookId: number) => {
    try {
      const response = await deleteBookAsFavourite(userId, bookId);
      if (response) {
        showSnackbar("Libro desmarcado como favorito", "success");
      }
    } catch (error) {
      console.error("Error unmarking book as favourite:", error);
      showSnackbar("Error al desmarcar el libro como favorito", "error");
    }
  };

  return (
    <BookContext.Provider
      value={{
        books,
        selectedBook,
        getBooks: fetchBooks,
        getReadBooks: fetchBooksByStatus,
        getBookDetail: fetchBookDetailBy,
        getAllBooks,
        markBookAsPlanToRead,
        markBookAsReading,
        markBookAsRead,
        deleteBook,
        getAuthorBooks,
        getFavoriteBooks: fetchFavoriteBooks,
        markBookAsFavourite: markBookAsFavouriteGiven,
        deleteBookAsFavourite: unmarkBookAsFavouriteGiven,
        getRecommendedBooks: fetchRecommendedBooks,
      }}
    >
      {children}
    </BookContext.Provider>
  );
};
