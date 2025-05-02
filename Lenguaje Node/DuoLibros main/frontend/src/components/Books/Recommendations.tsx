import { useContext, useEffect } from "react";
import { Typography, Rating, Box, Chip } from "@mui/material";
import { ThemeProvider, createTheme } from "@mui/material/styles";
import { BookData, BookContext } from "../../contexts/BookContext";
import ShowMore from "./ShowMore";
import { useNavigate } from "react-router-dom";
import { GenreLocalized } from "../../models/Genre";

const theme = createTheme();

export default function RecommendedBooks({ userId }: { userId?: number }) {
  const bookContext = useContext(BookContext);
  const { books, getRecommendedBooks } = bookContext;
  const navigate = useNavigate();

  useEffect(() => {
    getRecommendedBooks();
  }, []);

  const handleBookClick = (bookId: number) => {
    navigate(`/books/${bookId}`);
  };

  return (
    <ThemeProvider theme={theme}>
      <Box sx={{ px: 28, py: 4 }}>
        <Box display="flex" flexDirection="column" gap={3}>
          <Typography variant="h1" fontWeight="bold" fontSize="2.5rem">
            {userId ? "Libros recomendados" : "Libros recomendadoss"}
          </Typography>
          <Typography variant="h2" fontWeight="light" fontSize="1.5rem">
            {userId
              ? "Estos son los libros que te recomendamos, échales un vistazo!"
              : "Tu selección de libros recomendados"}
          </Typography>
        </Box>

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
                  <Box
                    sx={{
                      display: "flex",
                      flexDirection: "row",
                      gap: 2,
                      alignItems: "center",
                      justifyContent: "flex-start",
                    }}
                  >
                    <button
                      onClick={() => handleBookClick(book.id)}
                      className="flex"
                    >
                      <Typography variant="h4" className="font-bold text-black">
                        {book.title}
                      </Typography>
                    </button>
                    <Chip
                      size="small"
                      label={
                        GenreLocalized[
                          book.genre as keyof typeof GenreLocalized
                        ]
                      }
                      sx={{ marginTop: 0.35 }}
                    />
                  </Box>
                  <Typography variant="subtitle1" className="font-thin">
                    {book.author}
                  </Typography>
                  <ShowMore text={book.description} maxLength={200} />
                </Box>
              </Box>
            </div>
          ))
        ) : (
          <Typography
            variant="h6"
            className="font-thin"
            marginTop={2}
            color="gray"
          >
            No tenemos recomendaciones para vos, te recomendamos elegir tus
            favoritos.
          </Typography>
        )}
      </Box>
    </ThemeProvider>
  );
}
