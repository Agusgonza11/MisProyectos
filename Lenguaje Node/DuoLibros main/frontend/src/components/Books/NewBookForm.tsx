import React, { ChangeEvent, FormEvent } from "react";
import { useState, useEffect } from "react";
import {
  Box,
  Typography,
  TextField,
  Modal,
  Button,
  InputLabel,
  Select,
  MenuItem,
  FormControl,
} from "@mui/material";
import { styled } from "@mui/material/styles";
import { LoadingButton } from "@mui/lab";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { DateCalendar } from "@mui/x-date-pickers/DateCalendar";
import { DemoContainer, DemoItem } from "@mui/x-date-pickers/internals/demo";

import dayjs from "dayjs";

import { useForm, SubmitHandler } from "react-hook-form";
import { object, string, TypeOf, z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import useApiService from "../../services/apiService";
import CloudUploadIcon from "@mui/icons-material/CloudUpload";
import { Genre, GenreLocalized } from "../../models/Genre";

const VisuallyHiddenInput = styled("input")({
  clip: "rect(0 0 0 0)",
  clipPath: "inset(50%)",
  height: 1,
  overflow: "hidden",
  position: "absolute",
  bottom: 0,
  left: 0,
  whiteSpace: "nowrap",
  width: 1,
});

const formSchema = object({
  title: string(),
  isbn: string(),
  publishedDate: string(),
  genre: string(),
  description: string(),
  coverImage: z.instanceof(File).refine((file) => file.size > 0, {
    message: "Portada es requerida",
  }),
});

type BookInput = TypeOf<typeof formSchema>;

function NewBookForm({
  open,
  handleClose,
}: {
  open: boolean;
  handleClose: () => void;
}) {
  const [loading, setLoading] = useState(false);
  const { postBook } = useApiService();

  // Handle Form
  const {
    register,
    formState: { errors },
    reset,
    handleSubmit,
    setValue,
    watch,
  } = useForm<BookInput>({
    resolver: zodResolver(formSchema),
  });

  const resetValues = () => {
    setValue("publishedDate", new Date().toISOString());
    reset();
  };

  // Handle Submit
  const onSubmitHandler: SubmitHandler<BookInput> = (values) => {
    console.log(values);
    postNewBook(values);
  };

  async function postNewBook(values: BookInput) {
    setLoading(true);
    await postBook(values);
    setLoading(false);
  }

  useEffect(() => {
    setLoading(false);
    resetValues();
    setValue("publishedDate", new Date().toISOString());
  }, []);

  const handleFileChange = (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files;
    if (file && file.length > 0) {
      setValue("coverImage", file[0]);
    }
  };

  return (
    <Modal
      open={open}
      onClose={handleClose}
      aria-labelledby="modal-modal-title"
      aria-describedby="modal-modal-description"
    >
      <Box sx={style}>
        <Box
          component="form"
          noValidate
          autoComplete="off"
          onSubmit={handleSubmit(onSubmitHandler)}
          className="form-container"
        >
          <Typography variant="h5" align="left">
            Agregar nuevo libro
          </Typography>
          <TextField
            label="Título"
            fullWidth
            required
            error={!!errors["title"]}
            helperText={errors["title"] ? errors["title"].message : ""}
            {...register("title")}
          />
          <TextField
            label="ISBN"
            fullWidth
            required
            error={!!errors["isbn"]}
            helperText={errors["isbn"] ? errors["isbn"].message : ""}
            {...register("isbn")}
          />
          <Typography variant="body2">Fecha de publicación</Typography>
          <LocalizationProvider dateAdapter={AdapterDayjs}>
            <DemoContainer
              components={["DateCalendar"]}
              sx={{ alignSelf: "center" }}
            >
              <DemoItem label="">
                <DateCalendar
                  value={dayjs(watch("publishedDate"))}
                  onChange={(newValue) => {
                    if (newValue !== null) {
                      setValue("publishedDate", newValue.toISOString());
                    }
                  }}
                />
              </DemoItem>
            </DemoContainer>
          </LocalizationProvider>
          <FormControl fullWidth>
            <InputLabel id="demo-simple-select-label">Género</InputLabel>
            <Select
              label="Género"
              fullWidth
              required
              error={!!errors["genre"]}
              value={watch("genre")}
              {...register("genre")}
            >
              {Object.values(Genre).map((genre) => (
                <MenuItem value={genre} key={genre}>
                  {GenreLocalized[genre as keyof typeof GenreLocalized]}
                </MenuItem>
              ))}
            </Select>
          </FormControl>

          <TextField
            label="Descripción"
            fullWidth
            required
            error={!!errors["description"]}
            helperText={
              errors["description"] ? errors["description"].message : ""
            }
            {...register("description")}
          />
          <Box className="flex flex-row">
            <Typography className="mr-5">Portada: </Typography>
            <input
              type="file"
              onChange={(event) => {
                handleFileChange(event);
                register("coverImage").onChange(event);
              }}
              accept=".jpg,.jpeg,.png" // Specify accepted file types
            />
          </Box>

          <LoadingButton variant="contained" type="submit" loading={loading}>
            Add
          </LoadingButton>
        </Box>
      </Box>
    </Modal>
  );
}

export default NewBookForm;

const style = {
  position: "absolute" as const,
  top: "50%",
  left: "50%",
  transform: "translate(-50%, -50%)",
  height: "70%",
  bgcolor: "background.paper",
  borderRadius: 8,
  overflowY: "auto",
  padding: "60px",
};
