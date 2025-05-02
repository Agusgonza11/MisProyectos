import { useContext, useEffect, useState } from "react";
import {
  Typography,
  Rating,
  Box,
  Divider,
  Button,
  TextField,
} from "@mui/material";
import { ThemeProvider, createTheme } from "@mui/material/styles";
import { BookContext } from "../../contexts/BookContext";
import ShowMore from "./ShowMore";
import { formatIsoDate, transformGenre } from "./utils";
import useApiService from "../../services/apiService";
import BookReview from "./BookReview";
import { IconButton } from "@mui/material";
import { Favorite, FavoriteBorder } from "@mui/icons-material";
import BookStatusDropdown from "../Buttons/ButtonPerStatus";

export default function BookDetail({
  userId,
  bookId,
}: {
  userId?: number;
  bookId: number;
}) {
  const {
    selectedBook,
    getBookDetail,
    markBookAsFavourite,
    deleteBookAsFavourite,
  } = useContext(BookContext);

  const { books, getFavoriteBooks } = useContext(BookContext);
  const [isFavourite, setIsFavourite] = useState(false);
  const [bookReviews, setBookReviews] = useState<any[]>([]);
  const [userReview, setUserReview] = useState<any | null>(null);
  const [currentReview, setCurrentReview] = useState<any | null>({
    content: "",
    score: null,
  });
  const [isEditing, setIsEditing] = useState(false);

  const {
    postBookReview,
    getBookReviews,
    getBookReviewByUser,
    deleteBookReview,
    putBookReview,
  } = useApiService();

  const fetchBookReviewByUser = async () => {
    const userReview = await getBookReviewByUser(bookId, userId!);
    setUserReview(userReview[0]);
  };

  const handleAddReview = () => {
    postBookReview(bookId, currentReview).then(async () => {
      fetchBookReviewByUser();
    });
  };

  const handleDeleteReview = () => {
    deleteBookReview(userReview.id).then(async () => {
      setUserReview(null);
      setCurrentReview({ content: "", score: 0 });
      setIsEditing(false);
    });
  };

  const handleEditReview = () => {
    putBookReview(currentReview.id, currentReview).then(async () => {
      fetchBookReviewByUser();
      setCurrentReview({ content: "", score: 0 });
    });
  };

  const handleIsEditingReview = () => {
    if (isEditing) {
      setIsEditing(false);
      setCurrentReview({ content: "", score: 0 });
      fetchBookReviewByUser();
      return;
    }
    setIsEditing(true);
    setCurrentReview(userReview);
    setUserReview(null);
  };

  const handleToggleFavourite = () => {
    if (isFavourite) {
      deleteBookAsFavourite(userId!, bookId);
    } else {
      markBookAsFavourite(userId!, bookId);
    }
    setIsFavourite(!isFavourite);
  };

  const getBooksForList = (userId?: number) => {
    if (userId) {
      getFavoriteBooks(userId);
    }
  };

  useEffect(() => {
    getBooksForList(userId);
  }, [userId]);

  useEffect(() => {
    const isFav = books.some((book) => book.id === bookId);
    setIsFavourite(isFav);
  }, [books, bookId]);

  useEffect(() => {
    if (!isNaN(bookId)) {
      getBookDetail(bookId);

      (async () => {
        const reviews = await getBookReviews(bookId);
        setBookReviews(reviews);

        fetchBookReviewByUser();
      })();
    }
  }, [bookId]);

  return (
    <Box className="py-10 px-56">
      {selectedBook && (
        <Box className="flex flex-row gap-24">
          <Box className="relative flex flex-col gap-3">
            <img
              src={selectedBook.coverUrl}
              alt={selectedBook.title}
              className="w-64 object-cover"
            />
            <IconButton
              onClick={handleToggleFavourite}
              sx={{
                position: "absolute",
                top: 8,
                right: 8,
                fontSize: "2.5rem",
                backgroundColor: "rgb(256, 256, 256, 0.5)",
                borderRadius: "100%",
                justifyContent: "center",
                alignItems: "center",
              }}
            >
              {isFavourite ? (
                <Favorite sx={{ fontSize: "2.5rem", color: "#b32929" }} />
              ) : (
                <FavoriteBorder sx={{ fontSize: "2.5rem", color: "#b32929" }} />
              )}
            </IconButton>
            <BookStatusDropdown
              bookId={selectedBook.id}
              userId={userId ? userId : 0}
            ></BookStatusDropdown>
          </Box>
          <Box className="flex flex-col gap-3" sx={{ flex: 1 }}>
            <Box>
              <Typography variant="h3" className="font-bold">
                {selectedBook.title}
              </Typography>
              <Typography variant="h6" className="font-thin">
                {selectedBook.author}
              </Typography>

              <Rating
                precision={0.5}
                value={selectedBook.score}
                readOnly
                size="large"
              />

              <ShowMore text={selectedBook.description} maxLength={200} />

              <Box className="flex flex-col gap-1">
                <Typography variant="body1" className="font-thin">
                  Genres: {transformGenre(selectedBook.genre)}
                </Typography>

                <Typography variant="body1" className="font-thin">
                  Publicacion: {formatIsoDate(selectedBook.publishedDate)}
                </Typography>

                <Typography variant="body1" className="font-thin">
                  ISBN: {selectedBook.isbn}
                </Typography>
              </Box>
            </Box>

            <Divider></Divider>
            <Box style={{ display: "flex", gap: 10, flexDirection: "column" }}>
              <Typography variant="h4">Reseñas</Typography>
              <Box
                style={{
                  display: "flex",
                  flex: 1,
                  flexDirection: "row",
                  justifyContent: "space-between",
                }}
              >
                <Typography variant="h6">Mi Reseña</Typography>
                {!userReview && (
                  <Rating
                    precision={0.5}
                    size="large"
                    value={currentReview?.score}
                    onChange={(event, value) =>
                      setCurrentReview({ ...currentReview, score: value })
                    }
                  />
                )}
              </Box>
              {userReview ? (
                <>
                  <BookReview review={userReview} byUser={true} />
                  <Box
                    sx={{
                      display: "flex",
                      flexDirection: "row",
                      flex: 1,
                      gap: 1,
                    }}
                  >
                    <Button
                      color="error"
                      variant="outlined"
                      fullWidth
                      onClick={handleDeleteReview}
                    >
                      Eliminá tu Reseña
                    </Button>
                    <Button
                      variant="outlined"
                      onClick={handleIsEditingReview}
                      fullWidth
                    >
                      Editá tu Reseña
                    </Button>
                  </Box>
                </>
              ) : (
                <>
                  <TextField
                    id="outlined-basic"
                    label="Escribí tu reseña"
                    variant="outlined"
                    multiline
                    fullWidth
                    rows={2}
                    onChange={(event) =>
                      setCurrentReview({
                        ...currentReview,
                        content: event.target.value,
                      })
                    }
                    value={currentReview?.content}
                  />
                  {isEditing ? (
                    <Box
                      sx={{
                        display: "flex",
                        flexDirection: "row",
                        flex: 1,
                        gap: 1,
                        justifyContent: "flex-end",
                      }}
                    >
                      <Button
                        color="error"
                        variant="outlined"
                        onClick={handleIsEditingReview}
                      >
                        Cancelar
                      </Button>
                      <Button variant="outlined" onClick={handleEditReview}>
                        Guardar
                      </Button>
                    </Box>
                  ) : (
                    <Button variant="outlined" onClick={handleAddReview}>
                      Agregá tu Reseña
                    </Button>
                  )}
                </>
              )}
            </Box>
            <Divider></Divider>
            {bookReviews.length > 0 ? (
              bookReviews
                .sort(
                  (a, b) =>
                    new Date(b.date).getTime() - new Date(a.date).getTime()
                )
                .map((review) => {
                  if (review.user.id === userId) {
                    return null;
                  }
                  return <BookReview review={review} />;
                })
            ) : (
              <Typography variant="h6">No hay reseñas disponibles</Typography>
            )}
          </Box>
        </Box>
      )}
    </Box>
  );
}
