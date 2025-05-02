import { useContext, useEffect } from "react";
import { Typography, Rating, Box } from "@mui/material";
import { ThemeProvider, createTheme } from "@mui/material/styles";
import { BookData, BookContext } from "../../contexts/BookContext";
import ShowMore from "./ShowMore";
import { useNavigate } from "react-router-dom";

const theme = createTheme();

export default function AuthorBookList() {
  const bookContext = useContext(BookContext);
  const { books, getAuthorBooks } = bookContext;
  const navigate = useNavigate();

  useEffect(() => {
    getAuthorBooks();
  }, []);

  const handleBookClick = (bookId: number) => {
    navigate(`/books/${bookId}`);
  };

  return (
    <ThemeProvider theme={theme}>
      <div className="px-56 py-8">
        <div className="flex flex-col gap-3">
          <h1 className="text-4xl font-bold">Mis publicaciones</h1>

          <div className="text-2xl font-thin">
            Estos son los libros que has publicado
          </div>
        </div>

        {books.length > 0 ? (
          books.map((book: BookData) => (
            <div key={book.id} className="my-4">
              <Box className="flex flex-row gap-4">
                <button
                  onClick={() => handleBookClick(book.id)}
                  className="w-32 h-48 object-cover shrink-0"
                >
                  <img src={book.coverUrl} alt={book.title} />
                </button>
                <Box className="flex flex-col">
                  <button
                    onClick={() => handleBookClick(book.id)}
                    className="flex"
                  >
                    <Typography variant="h4" className="font-bold text-black">
                      {book.title}
                    </Typography>
                  </button>
                  <Typography variant="subtitle1" className="font-thin">
                    {book.author}
                  </Typography>

                  <Rating precision={0.5} value={book.score} readOnly />

                  <ShowMore text={book.description} maxLength={200}></ShowMore>
                </Box>
              </Box>
            </div>
          ))
        ) : (
          <Typography
            variant="h6"
            className="text-muted-foreground"
            p={2}
            color="gray"
          >
            No hay libros para mostrar
          </Typography>
        )}
      </div>
    </ThemeProvider>
  );
}
