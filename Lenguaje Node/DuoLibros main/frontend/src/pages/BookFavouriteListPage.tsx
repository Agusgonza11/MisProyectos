import React from "react";
import { BookProvider } from "../contexts/BookContext";
import BookFavouriteList from "../components/Books/FavouriteBooks";

export default function BookFavouriteListPage({ userId }: { userId?: number }) {
  return (
    <BookProvider>
      <div>
        <BookFavouriteList userId={userId} />
      </div>
    </BookProvider>
  );
}
