import * as React from "react";
import AppBar from "@mui/material/AppBar";
import Box from "@mui/material/Box";
import Toolbar from "@mui/material/Toolbar";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import Menu from "@mui/material/Menu";
import Container from "@mui/material/Container";
import Avatar from "@mui/material/Avatar";
import Button from "@mui/material/Button";
import Tooltip from "@mui/material/Tooltip";
import MenuItem from "@mui/material/MenuItem";
import { useNavigate } from "react-router-dom";
import { UserContext } from "../../contexts/UserContext";
import "./Header.css";
import NewBookButton from "../../components/Books/NewBookButton";
import { Autocomplete, TextField } from "@mui/material";
import SearchIcon from "@mui/icons-material/Search";
import InputAdornment from "@mui/material/InputAdornment";
import useApiService from "../../services/apiService";
import NotificationPage from "../../pages/NotificationPage";

const pages = [
  { name: "Libros", route: "books" },
  { name: "Mis Lecturas", route: "books/readings" },
  { name: "Favoritos", route: "favourite-books" },
  { name: "Recomendaciones", route: "recommended-books" },
  { name: "Mis Publicaciones", route: "books/author" },
  { name: "Metas", route: "goals" },
  { name: "Grupos", route: "groups" },
];

export default function Header() {
  const { logout, currentUser } = React.useContext(UserContext);
  const [books, setBooks] = React.useState<any[]>([]);
  const { getBooks } = useApiService();

  const navigate = useNavigate();

  const [anchorElUser, setAnchorElUser] = React.useState<null | HTMLElement>(
    null
  );

  const handleOpenUserMenu = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorElUser(event.currentTarget);
  };

  const handleCloseUserMenu = () => {
    setAnchorElUser(null);
  };

  const handleLogout = () => {
    logout();
    handleCloseUserMenu();
  };

  React.useEffect(() => {
    getBooks().then((books) => {
      setBooks(books);
    });
  }, []);

  return (
    <AppBar position="static">
      <Container maxWidth="xl">
        <Toolbar disableGutters>
          <Button
            key={"main"}
            onClick={() => navigate("/")}
            sx={{
              my: 2,
              color: "white",
              display: "block",
              textTransform: "lowercase",
            }}
          >
            <Box sx={{ display: "flex", flexDirection: "row" }}>
              <Typography sx={{ fontSize: 35, fontWeight: 300 }}>
                duo
              </Typography>
              <Typography sx={{ fontSize: 35, fontWeight: 400 }}>
                libros
              </Typography>
            </Box>
          </Button>
          <Box
            sx={{
              paddingLeft: 3,
              flexGrow: 1,
              display: { xs: "none", md: "flex" },
            }}
          >
            {pages.map((page) => (
              <Button
                key={page.name}
                onClick={() => navigate("/" + page.route)}
                sx={{
                  my: 2,
                  color: "white",
                  display: "block",
                  textTransform: "capitalize",
                }}
              >
                <Typography variant="body1">{page.name}</Typography>
              </Button>
            ))}
          </Box>
          <div
            style={{
              display: "flex",
              flexDirection: "row",
              gap: 20,
              alignItems: "center",
            }}
          >
            <Autocomplete
              size="small"
              freeSolo
              disableClearable
              options={books}
              getOptionLabel={(option) => {
                if (typeof option === "string") {
                  return option;
                }
                return option.title;
              }}
              onChange={(event: any, value) => {
                if (typeof value === "string") {
                  return;
                }
                navigate(`/books/${value.id}`);
              }}
              renderInput={(params) => (
                <>
                  <TextField
                    style={{
                      backgroundColor: "white",
                      borderRadius: 5,
                      width: 300,
                    }}
                    {...params}
                    placeholder="Buscar libro"
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
            <Tooltip title="Agregar Libro">
              <IconButton sx={{ p: 0 }}>
                <NewBookButton />
              </IconButton>
            </Tooltip>
            <NotificationPage />
            <Tooltip title="Ajustes">
              <IconButton onClick={handleOpenUserMenu} sx={{ p: 0 }}>
                <Avatar
                  alt={currentUser?.name}
                  src="/static/images/avatar/2.jpg"
                />
              </IconButton>
            </Tooltip>
            <Menu
              sx={{ mt: "45px" }}
              id="menu-appbar"
              anchorEl={anchorElUser}
              anchorOrigin={{
                vertical: "top",
                horizontal: "right",
              }}
              keepMounted
              transformOrigin={{
                vertical: "top",
                horizontal: "right",
              }}
              open={Boolean(anchorElUser)}
              onClose={handleCloseUserMenu}
            >
              <MenuItem key="logout" onClick={handleLogout}>
                <Typography textAlign="center">Cerrar Sesión</Typography>
              </MenuItem>
            </Menu>
          </div>
        </Toolbar>
      </Container>
    </AppBar>
  );
}
