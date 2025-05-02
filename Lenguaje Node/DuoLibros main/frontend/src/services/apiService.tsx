import { useContext } from "react";
import { UserContext } from "../contexts/UserContext";
import { SnackbarContext } from "../contexts/SnackbarContext";
import { GoalData } from "../models/Goal";

const API_URL = "http://localhost:8080";

const useApiService = () => {
  const { currentUser } = useContext(UserContext);
  const { showSnackbar } = useContext(SnackbarContext);
  const headerConfig = {
    "Content-Type": "application/json",
    Authorization: `Bearer ${currentUser?.token}`,
  };

  const loginUser = async (email: string, password: string) => {
    const url = `${API_URL}/auth/login`;
    try {
      const response = await fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ email, password }),
      });
      const responseJSON = await response.json();
      if (!response.ok) {
        console.log("ERROR");
        showSnackbar(responseJSON.message, "error");
        return null;
      }
      return responseJSON;
    } catch (e) {
      console.error(e);
    }
  };

  const registerUser = async (
    password: string,
    email: string,
    name: string,
    lastName: string
  ) => {
    const url = `${API_URL}/auth/register`;
    try {
      const response = await fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ password, email, name, lastName }),
      });
      const responseJSON = await response.json();
      if (!response.ok) {
        showSnackbar(responseJSON.message, "error");
        return null;
      }
      return responseJSON;
    } catch (e) {
      console.error(e);
    }
  };

  const getUserBalance = async (
    params: Record<string, string> | null = null
  ) => {
    if (!params) {
      params = {};
    }
    const qparams = new URLSearchParams(params).toString();
    const url = `${API_URL}/user/balance/${currentUser?.email}?${qparams}`;
    return await fetch(url, {
      method: "GET",
      headers: headerConfig,
    });
  };

  const getUserCategories = async (
    params: Record<string, string> | null = null
  ) => {
    // Fetch categories from API
    if (!params) {
      params = {};
    }
    const qparams = new URLSearchParams(params).toString();
    try {
      const url = `${API_URL}/categories/${currentUser?.email}?${qparams}`;
      const response = await fetch(url, {
        method: "GET",
        headers: headerConfig,
      });
      const categoriesData = await response.json();
      return categoriesData;
    } catch (e) {
      console.error(e);
      return [];
    }
  };

  const postUserCategory = async (body: string) => {
    // Post category to API and return response. Body is a JSON string.
    const url = `${API_URL}/categories/${currentUser?.email}`;
    const response = await fetch(url, {
      method: "POST",
      headers: headerConfig,
      body: body,
    });
    return response;
  };

  const putUserCategory = async (id: string, body: string) => {
    // Put category to API and return response. Body is a JSON string.
    const url = `${API_URL}/categories/${id}`;
    const response = await fetch(url, {
      method: "PUT",
      headers: headerConfig,
      body: body,
    });
    return response;
  };

  const deleteUserCategory = async (id: string) => {
    // Delete category to API and return response.
    const url = `${API_URL}/categories/${id}`;
    const response = await fetch(url, {
      method: "DELETE",
      headers: headerConfig,
    });
    return response;
  };

  const getUserTransactions = async (
    params: Record<string, string> | null = null
  ) => {
    if (!params) {
      params = {};
    }
    const qparams = new URLSearchParams(params).toString();

    const url = `${API_URL}/transactions/${currentUser?.email}?${qparams}`;
    const response = await fetch(url, {
      method: "GET",
      headers: headerConfig,
    });
    // const transactionsData: Promise<TransactionEntity[]> = await response.json();
    // return transactionsData;
  };

  const postUserTransaction = async (body: string) => {
    // Post transaction to API and return response. Body is a JSON string.
    const url = `${API_URL}/transactions/${currentUser?.email}`;
    const response = await fetch(url, {
      method: "POST",
      headers: headerConfig,
      body: body,
    });
    return response;
  };

  const putUserTransaction = async (id: string, body: string) => {
    // Put transaction to API and return response. Body is a JSON string.
    const url = `${API_URL}/transactions/${id}`;
    const response = await fetch(url, {
      method: "PUT",
      headers: headerConfig,
      body: body,
    });
    return response;
  };

  const deleteUserTransaction = async (id: string) => {
    // Delete transaction to API and return response.
    const url = `${API_URL}/transactions/${id}`;
    const response = await fetch(url, {
      method: "DELETE",
      headers: headerConfig,
    });
    return response;
  };

  const getReadBooks = async (userId: number) => {
    const url = `${API_URL}/books/status?userId=${userId}`;
    try {
      const response = await fetch(url, {
        method: "GET",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error fetching read books:", error);
    }
  };

  const getBookDetail = async (id: string) => {
    const url = `${API_URL}/books/${id}`;
    try {
      const response = await fetch(url, {
        method: "GET",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error fetching book detail:", error);
    }
  };

  const markAsPlanToRead = async (userId: number, bookId: number) => {
    const url = `${API_URL}/read-book/plan-to-read/${userId}/${bookId}`;
    try {
      const response = await fetch(url, {
        method: "PUT",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      showSnackbar("¡Libro marcado como plan para leer!", "success");
      const responseText = await response.text();
      return responseText ? JSON.parse(responseText) : null;
    } catch (error) {
      console.error("Error marking book as plan to read:", error);
      showSnackbar("Error al marcar el libro como plan para leer", "error");
    }
  };

  const markAsReading = async (userId: number, bookId: number) => {
    const url = `${API_URL}/read-book/reading/${userId}/${bookId}`;
    try {
      const response = await fetch(url, {
        method: "PUT",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      showSnackbar("¡Libro marcado como leyendo!", "success");
      const responseText = await response.text();
      return responseText ? JSON.parse(responseText) : null;
    } catch (error) {
      console.error("Error marking book as reading:", error);
      showSnackbar("Error al marcar el libro como leyendo", "error");
    }
  };

  const markAsRead = async (userId: number, bookId: number) => {
    const url = `${API_URL}/read-book/read/${userId}/${bookId}`;
    try {
      const response = await fetch(url, {
        method: "PUT",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      showSnackbar("¡Libro marcado como leído!", "success");
      const responseText = await response.text();
      return responseText ? JSON.parse(responseText) : null;
    } catch (error) {
      console.error("Error marking book as read:", error);
    }
  };

  const deleteBookFromLibrary = async (userId: number, bookId: number) => {
    const url = `${API_URL}/read-book/${userId}/${bookId}`;
    try {
      const response = await fetch(url, {
        method: "DELETE",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      showSnackbar("¡Libro eliminado de la biblioteca!", "success");
      return await response.json();
    } catch (error) {
      console.error("Error deleting book:", error);
      showSnackbar("Error al eliminar el libro de la biblioteca", "error");
    }
  };

  const markAsFavourite = async (userId: number, bookId: number) => {
    const url = `${API_URL}/favorite-books`;
    const body = JSON.stringify({ userId, bookId });
    try {
      const response = await fetch(url, {
        method: "POST",
        headers: {
          ...headerConfig,
          "Content-Type": "application/json",
        },
        body: body,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      showSnackbar("¡Libro marcado como favorito!", "success");
      return await response.json();
    } catch (error) {
      console.error("Error marking book as favourite:", error);
    }
  };

  const deleteBookAsFavourite = async (userId: number, bookId: number) => {
    const url = `${API_URL}/favorite-books?userId=${userId}&bookId=${bookId}`;
    try {
      const response = await fetch(url, {
        method: "DELETE",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      showSnackbar("¡Libro eliminado de favoritos!", "success");
      return await response.json();
    } catch (error) {
      console.error("Error removing book from favourites:", error);
    }
  };

  const getBooks = async () => {
    const url = `${API_URL}/books`;
    try {
      const response = await fetch(url, {
        method: "GET",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error fetching books:", error);
    }
  };

  const getFavouriteBooks = async (userId: number) => {
    const url = `${API_URL}/books/favorite?userId=${userId}`;
    try {
      const response = await fetch(url, {
        method: "GET",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error fetching books:", error);
    }
  };

  const getRecommendedBooks = async () => {
    const url = `${API_URL}/recommendations`;
    try {
      const response = await fetch(url, {
        method: "GET",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error fetching books:", error);
    }
  };

  const getAuthorBooksAPI = async () => {
    const url = `${API_URL}/books/author`;
    try {
      const response = await fetch(url, {
        method: "GET",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error fetching books:", error);
    }
  };

  const postBook = async (book: any) => {
    const url = `${API_URL}/books`;
    const formData = new FormData();

    // Append each field to the FormData object
    formData.append("title", book.title);
    formData.append("isbn", book.isbn);
    formData.append("author", book.author);
    formData.append("publishedDate", book.publishedDate);
    formData.append("genre", book.genre);
    formData.append("description", book.description);
    formData.append("coverImage", book.coverImage); // File object
    try {
      const response = await fetch(url, {
        method: "POST",
        body: formData,
        headers: {
          Authorization: `Bearer ${currentUser?.token}`,
        },
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      showSnackbar("Book published!", "success");
      return await response.json();
    } catch (error) {
      console.error("Error marking book as read:", error);
    }
  };

  const postBookReview = async (bookId: number, review: any) => {
    const url = `${API_URL}/reviews`;
    try {
      const response = await fetch(url, {
        method: "POST",
        headers: headerConfig,
        body: JSON.stringify({
          bookId,
          content: review.content,
          score: review.score,
          userId: currentUser?.id,
          createdAt: new Date().toISOString(),
        }),
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      showSnackbar("Review posted!", "success");
      return await response.json();
    } catch (error) {
      console.error("Error posting the review:", error);
    }
  };

  const getBookReviews = async (bookId: number) => {
    const url = `${API_URL}/reviews/${bookId}`;
    try {
      const response = await fetch(url, {
        method: "GET",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error fetching the reviews:", error);
    }
  };

  const getBookReviewByUser = async (bookId: number, userId: number) => {
    const url = `${API_URL}/reviews/${bookId}/${userId}`;
    try {
      const response = await fetch(url, {
        method: "GET",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error fetching the reviews:", error);
    }
  };

  const deleteBookReview = async (reviewId: number) => {
    const url = `${API_URL}/reviews/${reviewId}`;
    try {
      const response = await fetch(url, {
        method: "DELETE",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      showSnackbar("Review deleted!", "success");
      return await response.json();
    } catch (error) {
      console.error("Error deleting the review:", error);
    }
  };

  const putBookReview = async (reviewId: number, review: any) => {
    const url = `${API_URL}/reviews/${reviewId}`;
    try {
      const response = await fetch(url, {
        method: "PUT",
        headers: headerConfig,
        body: JSON.stringify({
          content: review.content,
          score: review.score,
          userId: currentUser?.id,
          bookId: review.bookId,
          createdAt: new Date().toISOString(),
        }),
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      showSnackbar("Review updated!", "success");
      return await response.json();
    } catch (error) {
      console.error("Error updating the review:", error);
    }
  };

  const editGoal = async (goalId: number, newProgress: number) => {
    const url = `${API_URL}/goals/${goalId}`;
    try {
      const response = await fetch(url, {
        method: "PUT",
        headers: headerConfig,
        body: JSON.stringify({
          amountRead: newProgress,
        }),
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      showSnackbar("Modified goal", "success");
      return await response.json();
    } catch (error) {
      console.error("Error modifying goal", error);
    }
  };

  const getGoals = async () => {
    const url = `${API_URL}/goals`;
    try {
      const response = await fetch(url, {
        method: "GET",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error fetching goals:", error);
    }
  };

  const createGoal = async (goal: GoalData) => {
    const url = `${API_URL}/goals`;
    try {
      const response = await fetch(url, {
        method: "POST",
        headers: headerConfig,
        body: JSON.stringify({
          type: goal.type,
          targetAmount: goal.targetAmount,
          startDate: new Date(goal.startDate),
          endDate: new Date(goal.endDate),
          notificationTime: goal.notificationTime,
          allowNotifications: goal.allowNotifications,
        }),
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error fetching goals:", error);
    }
  };

  const deleteGoal = async (goalId: number) => {
    const url = `${API_URL}/goals/${goalId}`;
    try {
      const response = await fetch(url, {
        method: "DELETE",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      showSnackbar("Goal deleted!", "success");
      return await response.json();
    } catch (error) {
      console.error("Error deleting the goal:", error);
    }
  };

  const getNotifications = async () => {
    const url = `${API_URL}/notifications`;
    try {
      const response = await fetch(url, {
        method: "GET",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return [];
      }
      return await response.json();
    } catch (error) {
      console.error("Error fetching notifications:", error);
      showSnackbar("Failed to fetch notifications.", "error");
      return [];
    }
  };

  const markNotificationAsViewed = async (notificationId: any) => {
    const url = `${API_URL}/notifications/${notificationId}/view`;
    try {
      const response = await fetch(url, {
        method: "PUT",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error(
        `Error marking notification ${notificationId} as viewed:`,
        error
      );
      showSnackbar("Failed to mark notification as viewed.", "error");
    }
  };

  const deleteNotification = async (notificationId: any) => {
    const url = `${API_URL}/notifications/${notificationId}`;
    try {
      const response = await fetch(url, {
        method: "DELETE",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      showSnackbar("Notification deleted successfully.", "success");
      return true;
    } catch (error) {
      console.error(`Error deleting notification ${notificationId}:`, error);
      showSnackbar("Failed to delete notification.", "error");
    }
  };

  const getGroups = async () => {
    const url = `${API_URL}/groups`;
    try {
      const response = await fetch(url, {
        method: "GET",
        headers: headerConfig,
      });
      const groupsData = await response.json();
      return groupsData;
    } catch (e) {
      console.error(e);
      return [];
    }
  };

  const createGroup = async (group: any) => {
    const url = `${API_URL}/groups`;
    try {
      const response = await fetch(url, {
        method: "POST",
        headers: headerConfig,
        body: JSON.stringify(group),
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error creating group:", error);
    }
  };

  const getGroupById = async (groupId: number) => {
    const url = `${API_URL}/groups/${groupId}`;
    const response = await fetch(url, {
      method: "GET",
      headers: headerConfig,
    });
    const groupData = await response.json();
    return groupData;
  };

  const joinGroup = async (groupId: number) => {
    const url = `${API_URL}/groups/${groupId}/join`;
    try {
      const response = await fetch(url, {
        method: "POST",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error joining group:", error);
    }
  };

  const leaveGroup = async (groupId: number) => {
    const url = `${API_URL}/groups/${groupId}/leave`;
    try {
      const response = await fetch(url, {
        method: "PUT",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error leaving group:", error);
    }
  };

  const deleteGroup = async (groupId: number) => {
    const url = `${API_URL}/groups/${groupId}`;
    try {
      const response = await fetch(url, {
        method: "DELETE",
        headers: headerConfig,
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error deleting group:", error);
    }
  };

  const editGroup = async (groupId: number, group: any) => {
    const url = `${API_URL}/groups/${groupId}`;
    try {
      const response = await fetch(url, {
        method: "PUT",
        headers: headerConfig,
        body: JSON.stringify(group),
      });
      if (!response.ok) {
        const errorMessage = await response.json();
        showSnackbar(errorMessage.message, "error");
        return null;
      }
      return await response.json();
    } catch (error) {
      console.error("Error editing group:", error);
    }
  };

  const getGroupGoals = async (groupId: number) => {
    const url = `${API_URL}/groups/${groupId}/completed-goals`;
    try {
      const response = await fetch(url, {
        method: "GET",
        headers: headerConfig,
      });
      const goalsData = await response.json();
      return goalsData;
    } catch (e) {
      console.error("Error getting group goals:", e);
      return [];
    }
  };

  return {
    loginUser,
    registerUser,
    getUserBalance,
    getUserCategories,
    postUserCategory,
    putUserCategory,
    deleteUserCategory,
    getUserTransactions,
    postUserTransaction,
    putUserTransaction,
    deleteUserTransaction,
    getBooks,
    getReadBooks,
    getBookDetail,
    markAsRead,
    postBook,
    markAsPlanToRead,
    markAsReading,
    deleteBookFromLibrary,
    getAuthorBooksAPI,
    markAsFavourite,
    getFavouriteBooks,
    deleteBookAsFavourite,
    postBookReview,
    getBookReviews,
    getBookReviewByUser,
    deleteBookReview,
    putBookReview,
    createGoal,
    getGoals,
    deleteGoal,
    editGoal,
    getNotifications,
    markNotificationAsViewed,
    deleteNotification,
    getGroups,
    createGroup,
    getGroupById,
    joinGroup,
    leaveGroup,
    deleteGroup,
    editGroup,
    getGroupGoals,
    getRecommendedBooks,
  };
};

export default useApiService;
