import React from "react";
import { BookProvider } from "../contexts/BookContext";
import RecommendedBooks from "../components/Books/Recommendations";

export default function RecommendedBooksPage({ userId }: { userId?: number }) {
  return (
    <BookProvider>
      <div>
        <RecommendedBooks userId={userId} />
      </div>
    </BookProvider>
  );
}
