import React, { useContext, useState } from "react";
import {
  Box,
  Typography,
  Button,
  Autocomplete,
  InputAdornment,
  TextField,
} from "@mui/material";
import { SnackbarContext } from "../contexts/SnackbarContext";
import useApiService from "../services/apiService";
import AddTaskIcon from "@mui/icons-material/AddTask";
import GroupItem from "../components/Groups/GroupItem";
import { Group } from "../models/Group";
import GroupForm from "../components/Groups/GroupForm";
import SearchIcon from "@mui/icons-material/Search";
import { useNavigate } from "react-router-dom";

export default function GroupsListPage({ userId }: { userId: number }) {
  const [groups, setGroups] = React.useState<Group[]>([]);
  const [openModal, setOpenModal] = useState(false);
  const navigate = useNavigate();

  const { getGroups } = useApiService();
  const { showSnackbar } = useContext(SnackbarContext);

  const fetchGroups = async () => {
    try {
      const groups = await getGroups();
      setGroups(groups);
    } catch (error) {
      showSnackbar("Error al obtener los grupos", "error");
    }
  };

  const handleDeleteGroup = async (goalId: number) => {
    try {
      // await deleteGoal(goalId);
      showSnackbar("Meta eliminada exitosamente", "success");
      // handleRefreshGoals();
    } catch (error) {
      showSnackbar("Error al eliminar la meta", "error");
    }
  };

  const handleCreateGroup = () => {
    setOpenModal(true);
  };

  const handleCloseModal = () => {
    setOpenModal(false);
  };

  const handleRefreshGroups = () => {
    fetchGroups();
  };

  React.useEffect(() => {
    handleRefreshGroups();
  }, [openModal]);

  const renderGroupsSection = (
    title: string,
    subtitle: string,
    groups: Group[],
    addVisible = false
  ) => (
    <Box>
      <Box
        sx={{
          display: "flex",
          flexDirection: "row",
          justifyContent: "space-between",
          px: 28,
        }}
      >
        <h1 className="text-4xl font-bold text-primary">{title}</h1>
        {addVisible && (
          <Button
            sx={{
              display: "flex",
              flexDirection: "row",
              gap: 1,
              alignItems: "center",
            }}
            onClick={handleCreateGroup}
            variant="contained"
            color="primary"
          >
            <AddTaskIcon /> Nuevo Grupo
          </Button>
        )}
      </Box>
      <div className="text-2xl font-thin text-muted-foreground px-56">
        {subtitle}{" "}
      </div>

      <Box sx={{ px: 30, display: "flex", flexDirection: "column" }}>
        {groups.length === 0 && (
          <Typography
            variant="h6"
            className="text-muted-foreground"
            sx={{ paddingY: 3 }}
          >
            No hay grupos para mostrar
          </Typography>
        )}
        {groups?.map((group: Group) => (
          <GroupItem
            key={group.id}
            group={group}
            handleDeleteGroup={() => handleDeleteGroup(group.id)}
            handleRefreshGroups={handleRefreshGroups}
          />
        ))}
      </Box>
    </Box>
  );

  return (
    <Box
      display="flex"
      flex={1}
      flexDirection="column"
      justifyContent="center"
      padding={3}
    >
      <Autocomplete
        sx={{ px: 28, py: 3 }}
        size="small"
        freeSolo
        disableClearable
        options={groups}
        getOptionLabel={(option) => {
          if (typeof option === "string") {
            return option;
          }
          return option.name;
        }}
        onChange={(event: any, value) => {
          if (typeof value === "string") {
            return;
          }
          navigate(`/groups/${value.id}`);
        }}
        renderInput={(params) => (
          <>
            <TextField
              style={{
                backgroundColor: "white",
                borderRadius: 5,
                width: "100%",
              }}
              {...params}
              placeholder="Buscar grupo"
              variant="outlined"
              slotProps={{
                input: {
                  ...params.InputProps,
                  startAdornment: (
                    <InputAdornment position="start">
                      <SearchIcon />
                    </InputAdornment>
                  ),
                  type: "search",
                },
              }}
            />
          </>
        )}
      />
      {renderGroupsSection(
        "Mis Grupos",
        "Estos son los grupos a los que perteneces",
        groups.filter((group) =>
          group.members?.some((member) => member.userId === userId)
        ),
        true
      )}
      {renderGroupsSection(
        "Otros Grupos",
        "Busca y unete a nuevos grupos",
        groups.filter(
          (group) => !group.members?.some((member) => member.userId === userId)
        )
      )}

      <GroupForm open={openModal} handleClose={handleCloseModal} />
    </Box>
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
