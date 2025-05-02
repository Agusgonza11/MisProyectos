import React, { useEffect, useState, useContext } from "react";
import "./RegisterForm.css";
import {
  Box,
  FormHelperText,
  TextField,
  FormControl,
  InputLabel,
  IconButton,
  OutlinedInput,
  InputAdornment,
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
  name: string()
    .nonempty("First name is required")
    .min(3, "First name must be at 3 char long"),
  lastName: string()
    .nonempty("Last name is required")
    .min(3, "Last name must be at 3 char long"),
  password: string()
    .nonempty("Password is required")
    .min(3, "Password must be at 3 char long"),
  confirmPwd: string(),
}).refine((data) => data.password === data.confirmPwd, {
  message: "Passwords don't match",
  path: ["confirmPwd"],
});

type RegisterInput = TypeOf<typeof formSchema>;

const RegisterForm: React.FC = () => {
  const navigate = useNavigate();
  const { signup } = useContext(UserContext);

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
    signUserUp(values);
  };

  async function signUserUp(values: RegisterInput) {
    setLoading(true);
    signup(values.password, values.email, values.name, values.lastName);
    setLoading(false);
  }

  useEffect(() => {
    setLoading(false);
    resetValues();
  }, []);

  return (
    <div className="page-container">
      <div className="flex flex-col border rounded-xl p-10 items-center justify-center gap-5">
        <div className="app-name">
          <p className="app-text">DUOLIBROS</p>
        </div>
        <Box
          component="form"
          noValidate
          autoComplete="off"
          onSubmit={handleSubmit(onSubmitHandler)}
          className="form-container"
        >
          <div style={{ display: "flex", flexDirection: "row", gap: 20 }}>
            {/* First Name Input */}
            <TextField
              label="First Name"
              fullWidth
              required
              error={!!errors["name"]}
              helperText={errors["name"] ? errors["name"].message : ""}
              {...register("name")}
            />
            {/* Last Name Input */}
            <TextField
              label="Last Name"
              fullWidth
              required
              error={!!errors["lastName"]}
              helperText={errors["lastName"] ? errors["lastName"].message : ""}
              {...register("lastName")}
            />
          </div>
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
              Create password
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
              label="Create password"
              {...register("password")}
            />
            <FormHelperText>
              {errors["password"] ? errors["password"].message : ""}
            </FormHelperText>
          </FormControl>

          {/* Confirm Password Input */}
          <FormControl
            variant="outlined"
            required
            fullWidth
            error={!!errors["confirmPwd"]}
          >
            <InputLabel htmlFor="outlined-adornment-confirmPwd">
              Confirm password
            </InputLabel>
            <OutlinedInput
              id="outlined-adornment-confirmPwd"
              type={showPassword ? "text" : "password"}
              label="Confirm Password"
              {...register("confirmPwd")}
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
            />
            <FormHelperText>
              {errors["confirmPwd"] ? errors["confirmPwd"].message : ""}
            </FormHelperText>
          </FormControl>
          <LoadingButton
            variant="contained"
            onClick={handleSubmit(onSubmitHandler)}
            type="submit"
            loading={loading}
          >
            Signup
          </LoadingButton>
        </Box>
        <p className="register-text" onClick={() => navigate("/login")}>
          Already have an account?<button>Login</button>
        </p>
      </div>
    </div>
  );
};

export default RegisterForm;
// https://codevoweb.com/form-validation-react-hook-form-material-ui-react/
