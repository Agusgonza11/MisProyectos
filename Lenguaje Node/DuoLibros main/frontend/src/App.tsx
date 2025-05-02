import React from "react";
import "./App.css";
import { UserProvider } from "./contexts/UserContext";
import { SnackbarProvider } from "./contexts/SnackbarContext";
import AppRouter from "./routing/AppRouter";
import { createTheme, ThemeProvider } from "@mui/material/styles";

// Theme:
const theme = createTheme({
  palette: {
    primary: {
      main: "#87442f",
    },
  },
});

function App() {
  return (
    <ThemeProvider theme={theme}>
      <SnackbarProvider>
        <UserProvider>
          <AppRouter />
        </UserProvider>
      </SnackbarProvider>
    </ThemeProvider>
  );
}

export default App;
