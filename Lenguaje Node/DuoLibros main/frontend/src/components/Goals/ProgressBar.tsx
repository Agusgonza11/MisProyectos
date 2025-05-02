import React from "react";
import { Box, Typography } from "@mui/material";

function ProgressBar({ progress }: { progress: number }) {
  const colors = {
    0: "#f44336",
    25: "#ff9800",
    50: "#ffc107",
    75: "#4caf50",
    100: "#4caf50",
  };

  const getColor = (progress: number) => {
    if (progress < 25) return colors[0];
    if (progress < 50) return colors[25];
    if (progress < 75) return colors[50];
    if (progress < 100) return colors[75];
    return colors[100];
  };

  return (
    <Box sx={styles.component}>
      <Box sx={styles.header}>
        <Typography sx={{ fontWeight: 500, color: "#AAA" }}>
          PROGRESO
        </Typography>
        <Typography
          sx={{ fontWeight: 500, color: "#AAA" }}
        >{`${progress}%`}</Typography>
      </Box>
      <Box sx={styles.progressBar}>
        <Box
          sx={{
            ...styles.progress,
            width: `${Math.min(progress + 10, 100)}%`,
            background: `linear-gradient(to right, ${getColor(
              progress
            )} ${progress}%, #DDD)`,
          }}
        />
      </Box>
    </Box>
  );
}

export default ProgressBar;

const styles = {
  component: {
    display: "flex",
    flexDirection: "column",
  },
  header: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  progressBar: {
    width: "100%",
    height: "10px",
    borderRadius: "8px",
    background: "#DDD",
    marginBottom: "6px",
  },
  progress: {
    height: "100%",
    borderRadius: "8px",
    transition: "all 1.5s ease",
  },
};
