import * as React from "react";
import LinearProgress, {
  LinearProgressProps,
} from "@mui/material/LinearProgress";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import { UserRole } from "../../models/Group";

function LinearProgressWithLabel(
  props: LinearProgressProps & {
    value: number;
    completedGoals: number;
  }
) {
  return (
    <Box sx={{ display: "flex", alignItems: "center", padding: 1 }}>
      <Box sx={{ width: "100%", mr: 1 }}>
        <LinearProgress
          variant="determinate"
          {...props}
          sx={{ height: 8, borderRadius: 1 }}
        />
      </Box>
      <Box sx={{ minWidth: 35 }}>
        <Typography
          variant="body2"
          sx={{ fontSize: 15 }}
        >{`${props.completedGoals}`}</Typography>
      </Box>
    </Box>
  );
}

export default function LinearWithValueLabel({
  maxGoalQuantity,
  completedGoals,
  userRole,
}: {
  maxGoalQuantity: number;
  completedGoals: number;
  userRole: UserRole;
}) {
  return (
    <Box sx={{ width: "100%" }}>
      <LinearProgressWithLabel
        value={(completedGoals / maxGoalQuantity) * 100}
        completedGoals={completedGoals}
        color={userRole === UserRole.OWNER ? "secondary" : "primary"}
      />
    </Box>
  );
}
