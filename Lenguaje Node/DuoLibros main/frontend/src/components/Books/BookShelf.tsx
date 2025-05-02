import React, { useContext, useEffect } from "react";
import {
  Box,
  createTheme,
  Grid,
  IconButton,
  Paper,
  Tooltip,
  Typography,
} from "@mui/material";
import {
  Book,
  BookmarkBorder,
  CheckCircleOutline,
  Delete,
} from "@mui/icons-material";
import { BookContext, BookData, BookStatus } from "../../contexts/BookContext";
import { useNavigate } from "react-router-dom";

export default function BookShelf({ userId }: { userId: number }) {
  const bookContext = useContext(BookContext);
  const {
    books,
    getAllBooks,
    markBookAsPlanToRead,
    markBookAsReading,
    markBookAsRead,
    deleteBook,
  } = bookContext;
  const navigate = useNavigate();

  useEffect(() => {
    if (userId) {
      getAllBooks(userId);
    }
  }, [userId]);

  const handleBookClick = (bookId: number) => {
    navigate(`/books/${bookId}`);
  };

  const renderBookSection = (
    title: string,
    books: BookData[],
    userId: number
  ) => (
    <Box className="card-container" key={title} sx={{ mb: 4 }}>
      <Typography
        variant="h5"
        component="h2"
        gutterBottom
        className="section-title"
      >
        {title}
      </Typography>

      {books.length > 0 ? (
        <Grid container spacing={3}>
          {books.map((book) => (
            <Grid item xs={6} sm={4} md={3} lg={2} key={book.id}>
              <Paper elevation={3} className="card">
                <img
                  src={book.coverUrl}
                  alt={book.title}
                  className="book-title w-full object-cover shrink-0"
                  onClick={() => handleBookClick(book.id)}
                />
                <Typography
                  variant="subtitle2"
                  align="center"
                  className="text-ellipsis"
                >
                  {book.title}
                </Typography>
                <Box className="shelf">
                  <Tooltip title="Planeo leer">
                    <IconButton
                      onClick={() => markBookAsPlanToRead(userId, book.id)}
                      size="small"
                    >
                      <BookmarkBorder />
                    </IconButton>
                  </Tooltip>
                  <Tooltip title="Actualmente leyendo">
                    <IconButton
                      onClick={() => markBookAsReading(userId, book.id)}
                      size="small"
                    >
                      <Book />
                    </IconButton>
                  </Tooltip>
                  <Tooltip title="Leído">
                    <IconButton
                      onClick={() => markBookAsRead(userId, book.id)}
                      size="small"
                    >
                      <CheckCircleOutline />
                    </IconButton>
                  </Tooltip>
                  <Tooltip title="Borrar">
                    <IconButton
                      onClick={() => deleteBook(userId, book.id)}
                      size="small"
                    >
                      <Delete />
                    </IconButton>
                  </Tooltip>
                </Box>
              </Paper>
            </Grid>
          ))}
        </Grid>
      ) : (
        <Typography variant="body1" color="textSecondary" sx={{ mt: 2 }}>
          No tienes libros en esta sección.
        </Typography>
      )}
    </Box>
  );

  return books.filter((book: BookData) => book.status === BookStatus.Reading)
    .length === 0 &&
    books.filter((book: BookData) => book.status === BookStatus.PlanToRead)
      .length === 0 &&
    books.filter((book: BookData) => book.status === BookStatus.Read).length ===
      0 ? (
    <div className="mx-auto px-56 py-8">
      <div className="flex flex-col gap-3 mb-8">
        <h1 className="text-4xl font-bold text-primary">Mis Lecturas</h1>
        <div className="text-2xl font-light text-muted-foreground">
          Estos son los libros que has leído
        </div>
      </div>
      <div className="text-2xl font-thin">
        No tienes libros en tu estantería
      </div>
    </div>
  ) : (
    <div className="mx-auto px-56 py-8">
      <div className="flex flex-col gap-3 mb-8">
        <h1 className="text-4xl font-bold text-primary">Mis Lecturas</h1>
        <div className="text-2xl font-thin text-muted-foreground">
          Estos son los libros que has leído
        </div>
      </div>
      {renderBookSection(
        "Actualmente leyendo",
        books.filter((book: BookData) => book.status === BookStatus.Reading),
        userId
      )}
      {renderBookSection(
        "Planeo leer",
        books.filter((book: BookData) => book.status === BookStatus.PlanToRead),
        userId
      )}
      {renderBookSection(
        "Leído",
        books.filter((book: BookData) => book.status === BookStatus.Read),
        userId
      )}
    </div>
  );
}
