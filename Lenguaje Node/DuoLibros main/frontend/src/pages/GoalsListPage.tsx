import React, { useContext, useEffect, useState } from "react";
import { Box, Typography } from "@mui/material";
import { Goal } from "../models/Goal";
import GoalCard from "../components/Goals/GoalCard";
import { SnackbarContext } from "../contexts/SnackbarContext";
import useApiService from "../services/apiService";
import NewGoalForm from "../components/Goals/NewGoalForm";
import AddTaskIcon from "@mui/icons-material/AddTask";

export default function GoalsListPage({ userId }: { userId: number }) {
  const [goals, setGoals] = React.useState<Goal[]>([]);
  const [openModal, setOpenModal] = useState(false);

  const { getGoals, deleteGoal } = useApiService();
  const { showSnackbar } = useContext(SnackbarContext);

  const fetchGoals = async () => {
    try {
      const goals = await getGoals();
      setGoals(goals);
    } catch (error) {
      showSnackbar("Error al obtener las metas", "error");
    }
  };

  const handleDeleteGoal = async (goalId: number) => {
    try {
      await deleteGoal(goalId);
      showSnackbar("Meta eliminada exitosamente", "success");
      handleRefreshGoals();
    } catch (error) {
      showSnackbar("Error al eliminar la meta", "error");
    }
  };

  const handleAddGoal = () => {
    setOpenModal(true);
  };

  const handleCloseModal = () => {
    setOpenModal(false);
  };

  const handleRefreshGoals = () => {
    fetchGoals();
  };

  useEffect(() => {
    handleRefreshGoals();
  }, [openModal]);

  const renderGoalsSection = (
    title: string,
    goals: Goal[],
    addVisible = false
  ) => (
    <Box className="card-container" key={title} sx={{ mb: 4 }}>
      <Typography
        variant="h5"
        component="h2"
        gutterBottom
        className="section-title px-56"
      >
        {title}
      </Typography>
      <Box
        sx={{
          display: "flex",
          overflowX: "scroll",
          gap: 4,
          padding: 2,
          paddingLeft: 30,
          "&::-webkit-scrollbar": {
            display: "none",
          },
        }}
      >
        {addVisible && (
          <Box
            sx={styles.newGoalCard}
            component="button"
            onClick={handleAddGoal}
          >
            <AddTaskIcon sx={styles.newGoalIcon} />
            <Typography sx={styles.newGoalCardText}>Agregar Meta</Typography>
          </Box>
        )}
        {goals?.map((goal: Goal) => (
          <GoalCard
            key={goal.id}
            goal={goal}
            handleDeleteGoal={() => handleDeleteGoal(goal.id)}
            handleRefreshGoals={handleRefreshGoals}
          />
        ))}
      </Box>
    </Box>
  );

  return (
    <div className="mx-auto py-8">
      <div className="flex px-56 flex-col gap-3 mb-8">
        <h1 className="text-4xl font-bold text-primary">Mis Metas</h1>
        <div className="text-2xl font-thin text-muted-foreground">
          Estos son las metas que te has propuesto
        </div>
      </div>

      {renderGoalsSection(
        "En Progreso",
        goals
          .filter((goal) => !goal.completed)
          .sort(
            (a, b) =>
              new Date(a.endDate).getTime() - new Date(b.endDate).getTime()
          ),
        true
      )}
      {renderGoalsSection(
        "Completados",
        goals.filter((goal) => goal.completed)
      )}

      <NewGoalForm
        open={openModal}
        handleClose={handleCloseModal}
        handleConfirm={handleRefreshGoals}
      />
    </div>
  );
}

const styles = {
  newGoalCard: {
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    justifyContent: "center",
    width: "300px",
    height: "400px",
    minWidth: "300px",
    padding: "1rem",
    border: "3px dashed #ccc",
    backgroundColor: "#f9f9f9",
    borderRadius: "8px",
    cursor: "pointer",
    transition: "all 0.3s ease",
    gap: "1rem",
    "&:hover": {
      borderColor: "#aaa",
    },
  },
  newGoalIcon: {
    fontSize: "4rem",
    color: "#ccc",
  },
  newGoalCardText: {
    fontSize: "1.2rem",
    color: "#aaa",
  },
};
