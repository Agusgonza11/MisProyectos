import React, { useState, useEffect, useContext } from "react";
import { Box, Button, Modal, TextField, Typography } from "@mui/material";
import { LoadingButton } from "@mui/lab";
import { useForm, SubmitHandler } from "react-hook-form";
import { number, object, TypeOf } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import useApiService from "../../services/apiService";
import { SnackbarContext } from "../../contexts/SnackbarContext";
import { Goal, getGoalTypeText } from "../../models/Goal";

function ProgressGoalForm({
  open,
  handleClose,
  goal,
}: {
  open: boolean;
  handleClose: () => void;
  goal: Goal;
}) {
  const [loading, setLoading] = useState(false);
  const { editGoal } = useApiService();
  const { showSnackbar } = useContext(SnackbarContext);

  const formSchema = object({
    amountRead: number()
      .positive(
        `El número de ${getGoalTypeText(
          goal.type
        ).toLowerCase()} debe ser positivo`
      )
      .max(
        goal.targetAmount - goal.amountRead,
        `El número de ${getGoalTypeText(
          goal.type
        ).toLowerCase()} no puede ser mayor a la meta.`
      ),
  });

  type GoalInput = TypeOf<typeof formSchema>;

  // Handle Form
  const {
    formState: { errors },
    reset,
    handleSubmit,
    setValue,
    watch,
  } = useForm<GoalInput>({
    resolver: zodResolver(formSchema),
  });

  const resetValues = () => {
    reset();
  };

  // Handle Submit
  const onSubmitHandler: SubmitHandler<GoalInput> = (values) => {
    postNewGoal(values);
  };

  async function postNewGoal(values: GoalInput) {
    setLoading(true);
    try {
      await editGoal(goal.id, values.amountRead);
      showSnackbar("Progreso agregado exitosamente", "success");
      handleClose();
    } catch (error) {
      showSnackbar(`Error al agregar progreso a la meta: ${error}`, "error");
    }
    setLoading(false);
  }

  useEffect(() => {
    setLoading(false);
    resetValues();
  }, []);

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
            Agregar Progreso
          </Typography>

          <TextField
            label={`Cantidad de ${getGoalTypeText(
              goal.type
            ).toLowerCase()} leídos`}
            type="number"
            value={watch("amountRead")}
            onChange={(e) => setValue("amountRead", Number(e.target.value))}
            InputProps={{ inputProps: { min: 0 } }}
            fullWidth
            error={!!errors.amountRead}
            helperText={errors.amountRead?.message}
          />

          <Box
            display="flex"
            justifyContent="flex-end"
            width="100%"
            mt={2}
            gap={2}
          >
            <Button onClick={handleClose} color="inherit">
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

export default ProgressGoalForm;

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
