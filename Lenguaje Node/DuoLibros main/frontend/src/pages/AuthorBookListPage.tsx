import React from "react";
import { BookProvider } from "../contexts/BookContext";
import AuthorBookList from "../components/Books/AuthorBooks";

export default function AuthorBookListPage() {
  return (
    <BookProvider>
      <div>
        <AuthorBookList />
      </div>
    </BookProvider>
  );
}
