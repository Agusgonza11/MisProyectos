import React, { useState, useEffect, useContext } from "react";
import {
  Box,
  Button,
  Modal,
  TextField,
  Typography,
  FormGroup,
  FormControlLabel,
  Switch,
  FormControl,
  InputLabel,
  Input,
  FormHelperText,
} from "@mui/material";
import { LoadingButton } from "@mui/lab";
import { useForm, SubmitHandler } from "react-hook-form";
import { boolean, number, object, string, TypeOf, z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import useApiService from "../../services/apiService";
import { GoalTypes } from "../../models/Goal";
import { SnackbarContext } from "../../contexts/SnackbarContext";

const formSchema = object({
  targetAmount: number().positive(),
  type: z.nativeEnum(GoalTypes),
  startDate: string(),
  endDate: string(),
  allowNotifications: boolean().default(true),
  notificationTime: string().default("09:00"),
}).refine((obj) => new Date(obj.endDate) > new Date(obj.startDate), {
  message: "La fecha límite debe ser posterior a la fecha de inicio",
  path: ["endDate"],
});

type GoalInput = TypeOf<typeof formSchema>;

function NewGoalForm({
  open,
  handleClose,
  handleConfirm,
}: {
  open: boolean;
  handleClose: () => void;
  handleConfirm: () => void;
}) {
  const [loading, setLoading] = useState(false);
  const [allowNotifications, setAllowNotifications] = useState(true);
  const { createGoal } = useApiService();
  const { showSnackbar } = useContext(SnackbarContext);

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
    setValue("type", GoalTypes.Pages);
  };

  // Handle Submit
  const onSubmitHandler: SubmitHandler<GoalInput> = (values) => {
    postNewGoal(values);
  };

  async function postNewGoal(values: GoalInput) {
    setLoading(true);
    try {
      await createGoal(values);
      showSnackbar("Meta agregada exitosamente", "success");
      handleConfirm();
      handleClose();
    } catch (error) {
      showSnackbar(`Error al crear la meta: ${error}`, "error");
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
            Nueva Meta
          </Typography>

          <Box display="flex" gap={2} width="100%" justifyContent="center">
            <Button
              color="warning"
              variant={
                watch("type") === GoalTypes.Pages ? "contained" : "outlined"
              }
              fullWidth
              onClick={() => setValue("type", GoalTypes.Pages)}
            >
              Páginas
            </Button>
            <Button
              color="secondary"
              variant={
                watch("type") === GoalTypes.Books ? "contained" : "outlined"
              }
              onClick={() => setValue("type", GoalTypes.Books)}
              fullWidth
            >
              Libros
            </Button>
          </Box>

          <TextField
            fullWidth
            label="Cantidad"
            type="number"
            margin="normal"
            onChange={(e) => setValue("targetAmount", Number(e.target.value))}
            error={!!errors.targetAmount}
            helperText={errors.targetAmount?.message}
          />

          <Box display="flex" gap={2} width="100%" justifyContent="center">
            <TextField
              fullWidth
              label="Fecha de Inicio"
              InputLabelProps={{ shrink: true }}
              type="date"
              value={watch("startDate")}
              onChange={(e) => setValue("startDate", e.target.value)}
              error={!!errors.startDate}
              helperText={errors.startDate?.message}
            />

            <TextField
              fullWidth
              label="Fecha Limite"
              InputLabelProps={{ shrink: true }}
              type="date"
              value={watch("endDate")}
              onChange={(e) => setValue("endDate", e.target.value)}
              error={!!errors.endDate}
              helperText={errors.endDate?.message}
            />
          </Box>

          <FormGroup>
            <FormControlLabel
              control={
                <Switch
                  defaultChecked
                  onChange={(e) => {
                    setValue("allowNotifications", e.target.checked);
                    setAllowNotifications(e.target.checked);
                  }}
                />
              }
              label="Activar notificaciones"
            />
          </FormGroup>

          <FormControl disabled={!allowNotifications} variant="standard">
            <InputLabel>Horario de notificacion</InputLabel>
            <Input
              id="component-disabled"
              type="time"
              value={watch("notificationTime") || "09:00"}
              onChange={(e) => setValue("notificationTime", e.target.value)}
              error={!!errors.notificationTime}
            />
            <FormHelperText>{errors.notificationTime?.message}</FormHelperText>
          </FormControl>

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

export default NewGoalForm;

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
