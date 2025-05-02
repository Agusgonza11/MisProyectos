import React from "react";
import {
  BrowserRouter as Router,
  Route,
  Routes,
  Navigate,
} from "react-router-dom";
import Layout from "../layout/Layout";
import { UserContext } from "../contexts/UserContext";
import BookListPage from "../pages/BookListPage"; // Adjust the path if needed
import { CircularProgress } from "@mui/material";
import AuthLayout from "../layout/AuthLayout";
import LoginPage from "../pages/LoginPage";
import RegisterPage from "../pages/RegisterPage";
import BookDetailPage from "../pages/BookDetailPage";
import AuthorBookListPage from "../pages/AuthorBookListPage";
import BookFavouriteListPage from "../pages/BookFavouriteListPage";
import BookShelfPage from "../pages/BookShelfPage";
import GoalsListPage from "../pages/GoalsListPage";
import GroupsListPage from "../pages/GroupsListPage";
import GroupDetailPage from "../pages/GroupDetailPage";
import RecommendedBooksPage from "../pages/BookRecommendationsPage";

function AppRouter() {
  const { currentUser, isLoading } = React.useContext(UserContext);

  return (
    <div>
      {isLoading ? (
        <CircularProgress
          sx={{ position: "absolute", top: "50%", left: "50%" }}
        />
      ) : (
        <Router>
          {currentUser ? (
            <Routes>
              <Route element={<Layout />}>
                <Route path="/" element={<Navigate to="/books" />} />
                <Route
                  path="/books/readings"
                  element={<BookShelfPage userId={currentUser.id} />}
                />
                <Route path="/books/author" element={<AuthorBookListPage />} />
                <Route path="/books" element={<BookListPage />} />
                <Route
                  path="/favourite-books"
                  element={<BookFavouriteListPage userId={currentUser.id} />}
                />
                <Route
                  path="/recommended-books"
                  element={<RecommendedBooksPage userId={currentUser.id} />}
                />
                <Route
                  path="/books/:bookId"
                  element={<BookDetailPage userId={currentUser.id} />}
                />
                <Route
                  path="/goals"
                  element={<GoalsListPage userId={currentUser.id} />}
                />
                <Route
                  path="/groups"
                  element={<GroupsListPage userId={currentUser.id} />}
                />
                <Route
                  path="/groups/:groupId"
                  element={<GroupDetailPage userId={currentUser.id} />}
                />
                <Route path="*" element={<Navigate to="/" />} />
              </Route>
            </Routes>
          ) : (
            <Routes>
              <Route element={<AuthLayout />}>
                <Route path="/" element={<Navigate to="/login" />} />
                <Route path="/login" element={<LoginPage />} />
                <Route path="/register" element={<RegisterPage />} />
                <Route path="*" element={<Navigate to="/" />} />
              </Route>
            </Routes>
          )}
        </Router>
      )}
    </div>
  );
}

export default AppRouter;
