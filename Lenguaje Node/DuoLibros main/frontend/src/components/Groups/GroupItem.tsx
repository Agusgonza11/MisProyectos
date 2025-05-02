import React from "react";
import { Group } from "../../models/Group";
import { Box, Typography } from "@mui/material";
import { useNavigate } from "react-router-dom";
import ShowMore from "../Books/ShowMore";
import GroupsIcon from "@mui/icons-material/Groups";

function GroupItem({
  group,
  handleDeleteGroup,
  handleRefreshGroups,
}: {
  group: Group;
  handleDeleteGroup: (groupId: number) => void;
  handleRefreshGroups: () => void;
}) {
  const navigate = useNavigate();

  const membersAmount = group.members.length;

  const handleGroupClick = () => {
    navigate(`/groups/${group.id}`);
  };

  return (
    <Box sx={styles.container}>
      <button
        onClick={() => handleGroupClick()}
        className="flex"
        style={{ justifyContent: "center", alignItems: "center" }}
      >
        <GroupsIcon
          sx={{
            color: "gray",
            backgroundColor: "#EEE",
            borderRadius: "50%",
            padding: "0.5rem",
            width: "70px",
            height: "70px",
          }}
        />
      </button>
      <Box sx={styles.body}>
        <button
          onClick={() => handleGroupClick()}
          className="flex"
          style={{ justifyContent: "flex-start" }}
        >
          <Typography variant="h6" className="font-bold text-black">
            {group.name}
          </Typography>
        </button>
        <Typography sx={styles.members}>
          {membersAmount} {membersAmount === 1 ? "miembro" : "miembros"}
        </Typography>
        <ShowMore text={group.description} maxLength={200}></ShowMore>
      </Box>
    </Box>
  );
}

export default GroupItem;

const styles = {
  container: {
    display: "flex",
    flexDirection: "row",
    alignItems: "center",
  },
  body: {
    display: "flex",
    flexDirection: "column",
    alignItems: "flex-start",
    justifyContent: "center",
    padding: "1rem",
    borderRadius: "0.5rem",
  },
  title: {
    fontSize: "1rem",
    fontWeight: "bold",
    marginBottom: "0.5rem",
  },
  description: {
    fontSize: "0.9rem",
    marginBottom: "0.5rem",
    fontWeight: "light",
  },
  members: {
    fontSize: "0.8rem",
    color: "#666",
  },
  button: {
    padding: "0.5rem",
    backgroundColor: "#f50057",
    color: "#fff",
    border: "none",
    borderRadius: "0.5rem",
    cursor: "pointer",
  },
};
