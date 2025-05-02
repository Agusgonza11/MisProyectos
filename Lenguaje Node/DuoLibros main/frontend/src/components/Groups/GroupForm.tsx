import React, { useState, useEffect, useContext } from "react";
import { Box, Button, Modal, TextField, Typography } from "@mui/material";
import { LoadingButton } from "@mui/lab";
import { useForm, SubmitHandler } from "react-hook-form";
import { object, string, TypeOf } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import useApiService from "../../services/apiService";
import { SnackbarContext } from "../../contexts/SnackbarContext";
import { Group } from "../../models/Group";

const formSchema = object({
  name: string(),
  description: string()
    .max(500)
    .refine((value) => value.trim().length > 0, {
      message: "La descripción no puede estar vacía",
    }),
});

type GroupInput = TypeOf<typeof formSchema>;

function GroupForm({
  open,
  handleClose,
  group,
}: {
  open: boolean;
  handleClose: () => void;
  group?: Group | null;
}) {
  const [loading, setLoading] = useState(false);
  const { createGroup, editGroup } = useApiService();
  const { showSnackbar } = useContext(SnackbarContext);

  // Handle Form
  const {
    formState: { errors },
    reset,
    handleSubmit,
    register,
    watch,
  } = useForm<GroupInput>({
    resolver: zodResolver(formSchema),
  });

  const resetValues = () => {
    reset();
  };

  // Handle Submit
  const onSubmitHandler: SubmitHandler<GroupInput> = async (values) => {
    if (group) {
      try {
        // Edit Group
        editGroup(group.id, values);
        showSnackbar("Grupo editado exitosamente", "success");
        handleClose();
      } catch (error) {
        showSnackbar(`Error al editar el grupo: ${error}`, "error");
      }
    } else {
      try {
        postNewGroup(values);
        showSnackbar("Grupo creado exitosamente", "success");
        handleClose();
      } catch (error) {
        showSnackbar(`Error al crear el grupo: ${error}`, "error");
      }
    }
  };

  async function postNewGroup(values: GroupInput) {
    setLoading(true);
    try {
      await createGroup(values);
      showSnackbar("Grupo creado exitosamente", "success");
      handleClose();
    } catch (error) {
      showSnackbar(`Error al crear el grupo: ${error}`, "error");
    }
    setLoading(false);
  }

  useEffect(() => {
    setLoading(false);
    if (group) {
      reset({
        name: group.name,
        description: group.description,
      });
    } else {
      resetValues();
    }
  }, [open]);

  return (
    <Modal open={open} onClose={handleClose}>
      <Box sx={style}>
        <Box
          component="form"
          noValidate
          autoComplete="off"
          onSubmit={handleSubmit(onSubmitHandler)}
          className="form-container"
        >
          <Typography variant="h6" component="h2" align="center" gutterBottom>
            {group ? "Editar Grupo" : "Nuevo Grupo"}
          </Typography>

          <TextField
            label="Nombre"
            fullWidth
            required
            error={!!errors["name"]}
            helperText={errors["name"] ? errors["name"].message : ""}
            value={watch("name")}
            {...register("name")}
          />

          <TextField
            label="Descripción"
            fullWidth
            multiline
            required
            error={!!errors["description"]}
            helperText={
              errors["description"] ? errors["description"].message : ""
            }
            value={watch("description")}
            {...register("description")}
          />

          <Box
            display="flex"
            justifyContent="flex-end"
            width="100%"
            mt={2}
            gap={2}
          >
            <Button
              onClick={() => {
                resetValues();
                handleClose();
              }}
              color="inherit"
            >
              Cancelar
            </Button>

            <LoadingButton variant="contained" type="submit" loading={loading}>
              Guardar
            </LoadingButton>
          </Box>
        </Box>
      </Box>
    </Modal>
  );
}

export default GroupForm;

const style = {
  position: "absolute" as const,
  top: "50%",
  left: "50%",
  transform: "translate(-50%, -50%)",
  bgcolor: "background.paper",
  borderRadius: 8,
  overflowY: "auto",
  padding: "60px",
};
