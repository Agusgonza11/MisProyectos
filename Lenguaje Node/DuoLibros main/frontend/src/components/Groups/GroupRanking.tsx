import React from "react";
import {
  Box,
  IconButton,
  Typography,
  Tooltip,
  Chip,
  Divider,
} from "@mui/material";
import { Group, UserRole } from "../../models/Group";
import LinearWithValueLabel from "./GroupProgressBar";
import useApiService from "../../services/apiService";
import { useParams } from "react-router-dom";

interface User {
  id: number;
  name: string;
  lastName: string;
  email: string;
  uid: string;
}

interface Goal {
  id: number;
  completed: boolean;
  createdAt: string;
  userId: number;
  startDate: string;
  endDate: string;
  user: User;
}

interface GoalsByUser {
  user: User;
  goals: Omit<Goal, "user">[];
}

const transformGoals = (goals: Goal[]): GoalsByUser[] => {
  // Agrupar metas por usuario
  const groupedByUser: { [userId: number]: Omit<Goal, "user">[] } =
    goals.reduce((acc, goal) => {
      const { user, ...goalWithoutUser } = goal; // Separar `user` de las metas
      if (!acc[user.id]) {
        acc[user.id] = [];
      }
      acc[user.id].push(goalWithoutUser);
      return acc;
    }, {} as { [userId: number]: Omit<Goal, "user">[] });

  // Convertir el objeto agrupado a la lista deseada
  const transformed: GoalsByUser[] = Object.entries(groupedByUser).map(
    ([userId, goalsWithoutUser]) => {
      // Encontrar el usuario correspondiente (asumimos que siempre existe)
      const user = goals.find((goal) => String(goal.user.id) === userId)!.user;
      return {
        user,
        goals: goalsWithoutUser,
      };
    }
  );

  console.log("Transformed:", transformed);

  return transformed;
};

function GroupRanking({ group }: { group: Group | null }) {
  const { groupId } = useParams();
  const [groupGoals, setGroupGoals] = React.useState<GoalsByUser[] | []>([]);
  const { getGroupGoals } = useApiService();
  const [maxGoalQuantity, setMaxGoalQuantity] = React.useState(0);

  const groupGoalsByUser = (completedGoals: Goal[]) => {
    const transformedGoals = transformGoals(completedGoals);

    // Máxima cantidad de metas completadas
    setMaxGoalQuantity(
      Math.max(...transformedGoals.map((userGoals) => userGoals.goals.length))
    );

    return transformedGoals;
  };

  React.useEffect(() => {
    getGroupGoals(parseInt(groupId!)).then((response) => {
      setGroupGoals(groupGoalsByUser(response));
    });
  }, [group]);

  return (
    <Box display="flex" flex={1} flexDirection="column" gap={1}>
      <Typography variant="h5">Ranking</Typography>
      <Typography variant="body2" color="gray">
        Basado en cantidad de metas cumplidas
      </Typography>
      <Divider />
      <Box>
        {groupGoals
          ?.sort((a, b) => {
            if (a.goals.length > b.goals.length) {
              return -1;
            } else {
              return 1;
            }
          })
          .map((userGoals) => (
            <Box key={userGoals.user.id}>
              <Box display="flex" alignItems="center" p={1} gap={1}>
                <Typography>{`${userGoals.user.name} ${userGoals.user.lastName}`}</Typography>
                <Chip
                  label={
                    userGoals.user.id === group?.createdBy
                      ? "Creador"
                      : "Miembro"
                  }
                  color={
                    userGoals.user.id === group?.createdBy
                      ? "secondary"
                      : "primary"
                  }
                  variant="outlined"
                  size="small"
                />
              </Box>
              <LinearWithValueLabel
                maxGoalQuantity={maxGoalQuantity}
                completedGoals={userGoals.goals.length}
                userRole={
                  userGoals.user.id === group?.createdBy
                    ? UserRole.OWNER
                    : UserRole.MEMBER
                }
              />
              <Divider />
            </Box>
          ))}
      </Box>
    </Box>
  );
}

export default GroupRanking;

const styles = {};
