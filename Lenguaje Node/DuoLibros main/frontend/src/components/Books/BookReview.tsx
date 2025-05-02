import React from "react";
import { Typography, Rating, Box, Divider, Avatar } from "@mui/material";

interface BookReviewProps {
  review: any;
  byUser?: boolean;
}

function BookReview({ review, byUser = false }: BookReviewProps) {
  const date = new Date(review.createdAt).toLocaleDateString("es-ES", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  return (
    <>
      <Box sx={styles.container}>
        <Box sx={styles.profileInfo}>
          <Avatar
            sx={{ marginBottom: 1 }}
            alt={review.user.name}
            src="/static/images/avatar/2.jpg"
          />
          <Typography variant="subtitle2">{review.user.name}</Typography>
          <Typography variant="subtitle2">{review.user.lastName}</Typography>
        </Box>
        <Box
          sx={{
            flex: 8,
            gap: 1,
            display: "flex",
            flexDirection: "column",
            justifyContent: "space-between",
          }}
        >
          <Box sx={{ display: "flex", gap: 1, flexDirection: "column" }}>
            <Box
              sx={{
                display: "flex",
                flexDirection: "row",
                justifyContent: "space-between",
              }}
            >
              <Rating precision={0.5} value={review.score} readOnly />
              <Typography variant="body2">{date}</Typography>
            </Box>
            <Box>
              {review.content === "" ? (
                <Typography
                  sx={{ fontStyle: "italic", color: "gray" }}
                  variant="body2"
                >
                  Sin descripción
                </Typography>
              ) : (
                <Typography variant="body2">{review.content}</Typography>
              )}
            </Box>
          </Box>
          {!byUser && <Divider sx={{ pt: 10 }} />}
        </Box>
      </Box>
    </>
  );
}

export default BookReview;

const styles = {
  container: {
    display: "flex",
    flex: 1,
    flexDirection: "row",
    gap: 5,
    pb: 1,
    justifyContent: "space-between",
  },
  profileInfo: {
    flex: 1,
    display: "flex",
    flexDirection: "column",
    justifyContent: "center",
    alignItems: "center",
  },
};
