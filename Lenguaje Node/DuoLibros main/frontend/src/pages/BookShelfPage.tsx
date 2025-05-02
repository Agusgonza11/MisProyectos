import React from "react";
import { BookProvider } from "../contexts/BookContext";
import BookShelf from "../components/Books/BookShelf";

export default function BookShelfPage({ userId }: { userId: number }) {
  return (
    <BookProvider>
      <div>
        <BookShelf userId={userId} />
      </div>
    </BookProvider>
  );
}
