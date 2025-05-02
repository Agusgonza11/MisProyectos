import { useContext, useEffect } from "react";
import { Typography, Rating, Box, Chip } from "@mui/material";
import { ThemeProvider, createTheme } from "@mui/material/styles";
import { BookData, BookContext } from "../../contexts/BookContext";
import ShowMore from "./ShowMore";
import { useNavigate } from "react-router-dom";
import { GenreLocalized } from "../../models/Genre";

const theme = createTheme();

export default function BookFavouriteList({ userId }: { userId?: number }) {
  const bookContext = useContext(BookContext);
  const { books, getFavoriteBooks } = bookContext;
  const navigate = useNavigate();

  const getBooksForList = (userId?: number) => {
    if (userId) {
      getFavoriteBooks(userId);
    }
  };

  useEffect(() => {
    getBooksForList(userId);
  }, [userId]);

  const handleBookClick = (bookId: number) => {
    navigate(`/books/${bookId}`);
  };

  return (
    <ThemeProvider theme={theme}>
      <div className="px-56 py-8">
        <div className="flex flex-col gap-3">
          <h1 className="text-4xl font-bold">
            {userId ? "Mis libros favoritos" : "Mis Libros Favoritos"}
          </h1>

          <div className="text-2xl font-thin">
            {userId
              ? "Estos son tus libros favoritos"
              : "Tu selección de favoritos"}
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
                      style={{ justifyContent: "flex-start" }}
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
                  <Rating precision={0.5} value={book.score} readOnly />
                  <ShowMore text={book.description} maxLength={200} />
                </Box>
              </Box>
            </div>
          ))
        ) : (
          <Typography variant="h6" className="font-thin" p={2} color="gray">
            No tienes libros favoritos
          </Typography>
        )}
      </div>
    </ThemeProvider>
  );
}
