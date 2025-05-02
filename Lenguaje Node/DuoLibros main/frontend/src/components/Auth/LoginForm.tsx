import React, { useEffect, useState, useContext } from "react";
import "./LoginForm.css";
import {
  Box,
  FormHelperText,
  TextField,
  FormControl,
  InputLabel,
  IconButton,
  OutlinedInput,
  InputAdornment,
  Typography,
} from "@mui/material";
import Visibility from "@mui/icons-material/Visibility";
import VisibilityOff from "@mui/icons-material/VisibilityOff";

import { LoadingButton } from "@mui/lab";

import { UserContext } from "../../contexts/UserContext";
import { useNavigate } from "react-router-dom";
import { useForm, SubmitHandler } from "react-hook-form";
import { object, string, TypeOf } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";

const formSchema = object({
  email: string().email().min(1, "Email is required"),
  password: string().min(1, "Password is required"),
});

type RegisterInput = TypeOf<typeof formSchema>;

const LoginForm: React.FC = () => {
  const navigate = useNavigate();
  const { login } = useContext(UserContext);

  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = React.useState(false);

  // Handle Password Visibility
  const handleClickShowPassword = () => setShowPassword((show) => !show);

  const handleMouseDownPassword = (
    event: React.MouseEvent<HTMLButtonElement>
  ) => {
    event.preventDefault();
  };

  // Handle Form
  const {
    register,
    formState: { errors },
    reset,
    handleSubmit,
  } = useForm<RegisterInput>({
    resolver: zodResolver(formSchema),
  });

  const resetValues = () => {
    reset();
  };

  // Handle Submit
  const onSubmitHandler: SubmitHandler<RegisterInput> = (values) => {
    logUserIn(values);
  };

  async function logUserIn(values: RegisterInput) {
    setLoading(true);
    login(values.email, values.password);
    setLoading(false);
  }

  useEffect(() => {
    setLoading(false);
    resetValues();
  }, []);

  return (
    <div className="page-container">
      <div className="flex flex-col border rounded-xl p-10 items-center justify-center gap-5">
        <Box sx={{ display: "flex", flexDirection: "row" }}>
          <Typography sx={{ fontSize: 35, fontWeight: 300 }}>duo</Typography>
          <Typography sx={{ fontSize: 35, fontWeight: 400 }}>libros</Typography>
        </Box>
        <Box
          component="form"
          noValidate
          autoComplete="off"
          onSubmit={handleSubmit(onSubmitHandler)}
          className="form-container"
        >
          {/* Email Input */}
          <TextField
            label="Email"
            fullWidth
            required
            error={!!errors["email"]}
            helperText={errors["email"] ? errors["email"].message : ""}
            {...register("email")}
          />
          {/* Password Input */}
          <FormControl
            variant="outlined"
            required
            fullWidth
            error={!!errors["password"]}
          >
            <InputLabel htmlFor="outlined-adornment-password">
              Password
            </InputLabel>
            <OutlinedInput
              id="outlined-adornment-password"
              type={showPassword ? "text" : "password"}
              endAdornment={
                <InputAdornment position="end">
                  <IconButton
                    aria-label="toggle password visibility"
                    onClick={handleClickShowPassword}
                    onMouseDown={handleMouseDownPassword}
                    edge="end"
                  >
                    {showPassword ? <VisibilityOff /> : <Visibility />}
                  </IconButton>
                </InputAdornment>
              }
              label="Password"
              {...register("password")}
            />
            <FormHelperText>
              {errors["password"] ? errors["password"].message : ""}
            </FormHelperText>
          </FormControl>
          <LoadingButton
            variant="contained"
            onClick={handleSubmit(onSubmitHandler)}
            type="submit"
            loading={loading}
          >
            Login
          </LoadingButton>
        </Box>
        <Typography component="span">
          Not a member?{" "}
          <button onClick={() => navigate("/register")}>
            <Typography
              component="span"
              sx={{ fontWeight: "bold" }}
              color="primary"
            >
              Sign Up
            </Typography>
          </button>
        </Typography>
      </div>
    </div>
  );
};

export default LoginForm;
// https://codevoweb.com/form-validation-react-hook-form-material-ui-react/
