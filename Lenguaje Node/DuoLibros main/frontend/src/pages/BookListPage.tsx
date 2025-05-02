import React from "react";
import BookList from "../components/Books/Books";
import { BookProvider } from "../contexts/BookContext";

export default function BookListPage({ userId }: { userId?: number }) {
  return (
    <BookProvider>
      <div>
        <BookList userId={userId} />
      </div>
    </BookProvider>
  );
}
