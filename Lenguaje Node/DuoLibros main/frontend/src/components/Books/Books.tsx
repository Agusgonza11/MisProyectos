import { useContext, useEffect, useState } from "react";
import {
  Typography,
  Rating,
  Box,
  TextField,
  Select,
  MenuItem,
  InputLabel,
  FormControl,
  Chip,
  Button,
} from "@mui/material";
import { ThemeProvider, createTheme } from "@mui/material/styles";
import { BookData, BookContext } from "../../contexts/BookContext";
import ShowMore from "./ShowMore";
import { useNavigate } from "react-router-dom";
import { Genre, GenreLocalized } from "../../models/Genre";
import SearchOffIcon from "@mui/icons-material/SearchOff";

export default function BookList({ userId }: { userId?: number }) {
  const bookContext = useContext(BookContext);
  const { books, getReadBooks, getBooks } = bookContext;

  const [filters, setFilters] = useState({
    isbn: "",
    title: "",
    genre: "",
    author: "",
  });
  const [filteredBooks, setFilteredBooks] = useState(books);

  const navigate = useNavigate();

  const getBooksForList = (userId?: number) => {
    if (userId) {
      getReadBooks(userId);
    } else {
      getBooks();
    }
  };

  useEffect(() => {
    getBooksForList(userId);
  }, [userId]);

  useEffect(() => {
    setFilteredBooks(
      books.filter(
        (book) =>
          book.isbn.toString().startsWith(filters.isbn) &&
          book.title.toLowerCase().startsWith(filters.title.toLowerCase()) &&
          book.author.toLowerCase().includes(filters.author.toLowerCase()) &&
          book.genre.toLowerCase().includes(filters.genre.toLowerCase())
      )
    );
  }, [filters, books]);

  const handleFilterChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFilters({
      ...filters,
      [name]: value,
    });
  };

  const handleBookClick = (bookId: number) => {
    navigate(`/books/${bookId}`);
  };

  const clearFilters = () => {
    setFilters({
      isbn: "",
      title: "",
      genre: "",
      author: "",
    });
  };

  return (
    <Box
      sx={{
        minHeight: "calc(100vh - 60px)",
        flex: 1,
        display: "flex",
        flexDirection: "row",
      }}
    >
      <Box
        sx={{
          width: "20%",
          padding: 5,
          display: "flex",
          flexDirection: "column",
          borderRight: "1px solid #e0e0e0",
        }}
      >
        <Typography variant="h6">Filtrar</Typography>
        <TextField
          label="ISBN"
          name="isbn"
          value={filters.isbn}
          onChange={handleFilterChange}
          fullWidth
          margin="normal"
          size="small"
          variant="standard"
          type="number"
        />
        <TextField
          type="search"
          label="Título"
          name="title"
          value={filters.title}
          onChange={handleFilterChange}
          fullWidth
          margin="normal"
          size="small"
          variant="standard"
        />
        <TextField
          type="search"
          label="Autor"
          name="author"
          value={filters.author}
          onChange={handleFilterChange}
          fullWidth
          margin="normal"
          size="small"
          variant="standard"
        />
        <Box sx={{ paddingTop: 2 }}>
          <FormControl fullWidth variant="standard">
            <InputLabel id="genre-select-standard-label">Género</InputLabel>
            <Select
              labelId="genre-select-standard-label"
              variant="standard"
              label="Genero"
              fullWidth
              required
              value={filters.genre}
              onChange={(event) =>
                setFilters({
                  ...filters,
                  genre: event.target.value as string,
                })
              }
            >
              {Object.values(Genre).map((genre) => (
                <MenuItem value={genre}>
                  {GenreLocalized[genre as keyof typeof GenreLocalized]}
                </MenuItem>
              ))}
            </Select>
          </FormControl>
        </Box>
        <Button onClick={clearFilters}>
          <Typography variant="button">Limpiar filtros</Typography>
        </Button>
      </Box>

      <Box
        sx={{ padding: 5, flex: 2, display: "flex", flexDirection: "column" }}
      >
        <div className="flex flex-col gap-3">
          <h1 className="text-4xl font-bold">
            {userId ? "Mis libros leidos" : "Libros"}
          </h1>

          <div className="text-2xl font-thin">
            {userId
              ? "Estos son tus libros leidos"
              : "Recomendaciones de nuestros usuarios"}
          </div>
        </div>
        {filteredBooks.length > 0 ? (
          filteredBooks.map((book: BookData) => (
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
                      <Typography variant="h4" className="font-bold text-black" sx={{ justifyContent: 'flex-start' }}>
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
                      clickable
                      onClick={() =>
                        setFilters({ ...filters, genre: book.genre })
                      }
                      sx={{ marginTop: 0.35 }}
                    />
                  </Box>
                  <button
                    onClick={() =>
                      setFilters({ ...filters, author: book.author })
                    }
                    className="flex"
                    style={{ justifyContent: "flex-start" }}
                  >
                    <Typography
                      color="primary"
                      variant="subtitle1"
                      className="font-thin"
                    >
                      {book.author}
                    </Typography>
                  </button>

                  <Rating precision={0.5} value={book.score} readOnly />

                  <ShowMore text={book.description} maxLength={200}></ShowMore>
                </Box>
              </Box>
            </div>
          ))
        ) : (
          <Box
            sx={{
              display: "flex",
              flex: 1,
              justifyContent: "center",
              alignItems: "center",
              flexDirection: "column",
            }}
          >
            <SearchOffIcon sx={{ fontSize: "5rem", color: "gray" }} />
            <Typography className="text-2xl font-thin" sx={{ color: "gray" }}>
              No se encontraron libros
            </Typography>
          </Box>
        )}
      </Box>
    </Box>
  );
}
