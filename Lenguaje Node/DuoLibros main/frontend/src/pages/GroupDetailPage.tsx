import React, { useContext, useReducer } from "react";
import { useParams, useNavigate } from "react-router-dom";
import useApiService from "../services/apiService";
import { Box, Typography, Avatar, Button } from "@mui/material";
import { Group } from "../models/Group";
import AddTaskIcon from "@mui/icons-material/AddTask";
import { SnackbarContext } from "../contexts/SnackbarContext";
import GroupForm from "../components/Groups/GroupForm";
import GroupRanking from "../components/Groups/GroupRanking";
import { set } from "react-hook-form";

function GroupDetailPage({ userId }: { userId?: number }) {
  const { groupId } = useParams();
  const { getGroupById, joinGroup, leaveGroup, deleteGroup } = useApiService();
  const [group, setGroup] = React.useState<Group | null>(null);
  const { showSnackbar } = useContext(SnackbarContext);
  const navigate = useNavigate();

  const [openModal, setOpenModal] = React.useState(false);

  const userIsGroupOwner = () => {
    return group?.createdBy === userId;
  };

  const userIsMember = () => {
    try {
      return group?.members?.some((member) => member.userId === userId);
    } catch (error) {
      navigate("/groups");
    }
  };

  const fetchGroup = async () => {
    await getGroupById(parseInt(groupId!)).then((response) => {
      if (response.statusCode != null) {
        showSnackbar("El grupo no existe", "error");
        navigate("/groups");
      }
      setGroup(response);
    });
  };

  const handleJoinGroup = async () => {
    try {
      await joinGroup(parseInt(groupId!));
      showSnackbar("Te has unido al grupo", "success");
      fetchGroup();
    } catch (error) {
      showSnackbar("Error al unirse al grupo", "error");
    }
  };

  const handleLeaveGroup = async () => {
    try {
      await leaveGroup(parseInt(groupId!));
      showSnackbar("Te has salido del grupo", "success");
      fetchGroup();
    } catch (error) {
      showSnackbar("Error al salir del grupo", "error");
    }
  };

  const handleEditGroup = async () => {
    setOpenModal(true);
  };

  const handleDeleteGroup = async () => {
    try {
      await deleteGroup(parseInt(groupId!));
      showSnackbar("Grupo eliminado exitosamente", "success");
      navigate("/groups");
    } catch (error) {
      showSnackbar("Error al eliminar el grupo", "error");
    }
  };

  React.useEffect(() => {
    fetchGroup();
  }, [groupId, openModal]);

  return (
    <Box
      sx={{
        minHeight: "calc(100vh - 100px)",
        flex: 1,
        display: "flex",
        flexDirection: "row",
        justifyContent: "space-between",
      }}
    >
      <Box
        className="py-10 pl-56 pr-10"
        sx={{ flex: 1, gap: 5, display: "flex", flexDirection: "column" }}
      >
        <Box
          sx={{
            display: "flex",
            flexDirection: "row",
            justifyContent: "space-between",
          }}
        >
          <h1 className="text-4xl font-bold text-primary">{group?.name}</h1>
          <Box sx={{ display: "flex", gap: 2 }}>
            {userIsGroupOwner() && (
              <>
                <Button
                  onClick={handleEditGroup}
                  variant="outlined"
                  color="primary"
                >
                  Editar
                </Button>
                <Button
                  onClick={handleDeleteGroup}
                  variant="outlined"
                  color="error"
                >
                  Eliminar
                </Button>
              </>
            )}
            {!userIsGroupOwner() &&
              (userIsMember() ? (
                <Button
                  onClick={handleLeaveGroup}
                  variant="contained"
                  color="primary"
                >
                  Abandonar
                </Button>
              ) : (
                <Button
                  onClick={handleJoinGroup}
                  variant="outlined"
                  color="primary"
                >
                  Unirse
                </Button>
              ))}
          </Box>
        </Box>
        <Box border={1} padding={2} borderRadius={1} borderColor="lightgray">
          <Typography variant="body1" className="font-thin">
            {group?.description}
          </Typography>
        </Box>
        <GroupRanking group={group} />
      </Box>
      <Box
        sx={{
          width: "20%",
          paddingX: 4,
          paddingTop: 6,
          display: "flex",
          flexDirection: "column",
          borderLeft: "1px solid #e0e0e0",
          minHeight: "100%",
        }}
      >
        <Typography variant="h5" className="font-bold">
          Miembros
        </Typography>
        <Typography
          variant="body1"
          className="font-thin"
          sx={{ color: "gray" }}
        >
          {group?.members.length}{" "}
          {group?.members.length === 1 ? "miembro" : "miembros"}
        </Typography>
        <Box className="flex flex-col gap-2" sx={{ paddingTop: 2 }}>
          {group?.members.map((member) => (
            <Box
              key={member.id}
              className="flex flex-row gap-2"
              sx={{ alignItems: "center" }}
            >
              <Avatar
                alt={member.user.name}
                src="/static/images/avatar/2.jpg"
              />
              <Typography
                variant="body1"
                sx={{
                  fontWeight:
                    member.user.id === group.createdBy ? "bold" : null,
                }}
              >
                {`${member.user.name} ${member.user.lastName}`}
              </Typography>
            </Box>
          ))}
        </Box>
      </Box>
      <GroupForm
        open={openModal}
        handleClose={() => setOpenModal(false)}
        group={group}
      />
    </Box>
  );
}

export default GroupDetailPage;
