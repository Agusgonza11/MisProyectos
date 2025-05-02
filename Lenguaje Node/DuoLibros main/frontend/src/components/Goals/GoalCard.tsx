import React from "react";
import {
  Box,
  IconButton,
  Typography,
  Tooltip,
  Chip,
  Divider,
} from "@mui/material";
import ProgressBar from "./ProgressBar";
import { Goal, getGoalTypeText, getColorByGoalType } from "../../models/Goal";
import HighlightOffIcon from "@mui/icons-material/HighlightOff";
import LoupeIcon from "@mui/icons-material/Loupe";
import ArrowCircleRightIcon from "@mui/icons-material/ArrowCircleRight";
import DeleteOutlineIcon from "@mui/icons-material/DeleteOutline";
import ProgressGoalForm from "./ProgressGoalForm";

const getFormattedDate = (date: string) => {
  return new Date(date).toLocaleDateString("es-ES", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
};

const getRemainingDays = (endDate: string) => {
  return Math.floor(
    (new Date(endDate).getTime() - new Date().getTime()) / (1000 * 60 * 60 * 24)
  );
};

const getRemainingColorText = (days: number) => {
  if (days <= 0) return "#f44336";
  if (days <= 3) return "#ff9800";
  return "gray";
};

function GoalCard({
  goal,
  handleDeleteGoal,
  handleRefreshGoals,
}: {
  goal: Goal;
  handleDeleteGoal: (goalId: number) => void;
  handleRefreshGoals: () => void;
}) {
  const [openProgressModal, setOpenProgressModal] = React.useState(false);

  const handleCloseProgressModal = () => {
    setOpenProgressModal(false);
  };

  const handleAddProgress = () => {
    setOpenProgressModal(true);
  };

  React.useEffect(() => {
    handleRefreshGoals();
  }, [openProgressModal]);

  return (
    <>
      <ProgressGoalForm
        open={openProgressModal}
        handleClose={handleCloseProgressModal}
        goal={goal}
      />

      <Box sx={styles.card}>
        <Box sx={styles.header}>
          <Box
            sx={{
              display: "flex",
              flexDirection: "row",
              justifyContent: "space-between",
              alignItems: "center",
              width: "100%",
            }}
          >
            <Typography variant="body1">Meta de Lectura</Typography>
            <Chip
              label={getGoalTypeText(goal.type)}
              sx={{
                backgroundColor: getColorByGoalType(goal.type),
                color: "white",
              }}
            />
          </Box>
          <Typography variant="body2" sx={{ color: "gray" }}>
            Para completar la meta debés leer: {goal.targetAmount}{" "}
            {getGoalTypeText(goal.type).toLowerCase()}.
          </Typography>
        </Box>
        <Box sx={styles.body}>
          <Box sx={styles.insideBox}>
            <ProgressBar progress={goal.progress} />
          </Box>
        </Box>
        <Box>
          <Box
            sx={{
              diplay: "flex",
              flexDirection: "row",
              width: "100%",
              textAlign: "center",
            }}
          >
            <Typography component="span" variant="h5">
              {goal.amountRead}
            </Typography>
            <Typography variant="h5" component="span" sx={{ color: "#aaa" }}>
              /{goal.targetAmount}{" "}
            </Typography>
            <Typography variant="body2" component="span" sx={{ color: "#aaa" }}>
              {getGoalTypeText(goal.type).toLowerCase()}
            </Typography>
            {!goal.completed && (
              <>
                <Typography
                  variant="h5"
                  component="span"
                  sx={{
                    color: getRemainingColorText(
                      getRemainingDays(goal.endDate)
                    ),
                    marginLeft: 2,
                  }}
                >
                  {Math.abs(getRemainingDays(goal.endDate))}{" "}
                </Typography>
                <Typography
                  variant="body2"
                  component="span"
                  sx={{
                    color: getRemainingColorText(
                      getRemainingDays(goal.endDate)
                    ),
                  }}
                >
                  {getRemainingDays(goal.endDate) <= 0
                    ? "días atrasado"
                    : "días restantes"}
                </Typography>
              </>
            )}
          </Box>

          <Chip label={getFormattedDate(goal.startDate)} color="default" />
          <ArrowCircleRightIcon
            sx={{ color: "#f44336", fontSize: 35, margin: 2 }}
          />
          <Chip label={getFormattedDate(goal.endDate)} color="default" />
        </Box>
        <Box sx={{ width: "100%" }}>
          <Divider sx={{ width: "100%" }} />
          <Box sx={[styles.footer]}>
            <Tooltip title="Eliminar">
              <IconButton
                component="button"
                onClick={() => handleDeleteGoal(goal.id)}
              >
                {goal.completed ? (
                  <DeleteOutlineIcon sx={{ fontSize: 38 }} />
                ) : (
                  <HighlightOffIcon sx={{ fontSize: 40 }} />
                )}
              </IconButton>
            </Tooltip>
            {!goal.completed && (
              <Box>
                <Tooltip title="Agregar Progreso">
                  <IconButton
                    component="button"
                    onClick={() => handleAddProgress()}
                  >
                    <LoupeIcon sx={{ fontSize: 40 }} />
                  </IconButton>
                </Tooltip>
              </Box>
            )}
          </Box>
        </Box>
      </Box>
    </>
  );
}

export default GoalCard;

const styles = {
  card: {
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    justifyContent: "center",
    width: "300px",
    minWidth: "300px",
    height: "400px",
    backgroundColor: "#f9f9f9",
    borderRadius: "8px",
    transition: "all 0.3s ease",
    gap: 2,
    "&:hover": {
      boxShadow: "0 2px 10px rgba(128, 128, 128, 0.2)",
    },
  },
  header: {
    display: "flex",
    flexDirection: "column",
    justifyContent: "space-between",
    alignItems: "center",
    width: "90%",
    paddingTop: "1.5rem",
    gap: "0.8rem",
  },
  body: {
    display: "flex",
    flexDirection: "column",
    justifyContent: "flex-start",
    alignItems: "center",
    width: "100%",
    flex: 1,
  },
  footer: {
    display: "flex",
    flexDirection: "row",
    gap: "1rem",
    justifyContent: "space-between",
    alignItems: "center",
    width: "100%",
    paddingY: "0.5rem",
    paddingX: "1rem",
    flex: 1,
  },
  text: {
    fontSize: "1.2rem",
    color: "#aaa",
  },
  insideBox: {
    width: "95%",
    padding: "1rem",
    backgroundColor: "#eee",
    borderRadius: 2,
  },
};
