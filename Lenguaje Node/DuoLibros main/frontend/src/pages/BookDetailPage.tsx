import { BookProvider } from "../contexts/BookContext";
import BookDetail from "../components/Books/BooksDetail";
import { useParams } from "react-router-dom";

export default function BookDetailPage({ userId }: { userId?: number }) {
  const { bookId } = useParams();

  return (
    <BookProvider>
      <div>
        <BookDetail userId={userId} bookId={parseInt(bookId!)} />
      </div>
    </BookProvider>
  );
}
