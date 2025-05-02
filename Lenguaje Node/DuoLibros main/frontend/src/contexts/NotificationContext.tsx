import React, { createContext, useState } from "react";
import useApiService from "../services/apiService";

interface NotificationContextProviderProps {
  children: React.ReactNode;
}

interface Notification {
  id: number;
  message: string;
  viewed: boolean;
  createdAt: string;
}

export type NotificationContextType = {
  notifications: Notification[];
  loading: boolean;
  fetchNotifications: () => void;
  markAsViewed: (id: number) => void;
  removeNotification: (id: number) => void;
};

const mockedNotifications = [
  {
    id: 1,
    message: "Nuevo mensaje recibido",
    viewed: false,
    createdAt: "2023-05-20T10:30:00Z",
  },
  {
    id: 2,
    message: "Tu libro fue marcado como favorito",
    viewed: true,
    createdAt: "2023-05-19T15:45:00Z",
  },
  {
    id: 3,
    message: "Tu libro obtuvo una nueva reseña",
    viewed: false,
    createdAt: "2023-05-18T09:00:00Z",
  },
];

export const NotificationContext = createContext<NotificationContextType>({
  notifications: [],
  loading: false,
  fetchNotifications: () => {},
  markAsViewed: (id: number) => {},
  removeNotification: (id: number) => {},
});

export const NotificationProvider: React.FC<
  NotificationContextProviderProps
> = ({ children }) => {
  const { getNotifications, markNotificationAsViewed, deleteNotification } =
    useApiService();

  const [notifications, setNotifications] =
    useState<Notification[]>(mockedNotifications);
  const [loading, setLoading] = useState(false);

  const fetchNotifications = async () => {
    setLoading(true);

    try {
      // Uncomment to fetch real data, use mock to test interface
      const fetchedNotifications = await getNotifications();
      setNotifications(fetchedNotifications);
      // setNotifications(mockedNotifications);
    } catch (error) {
      console.warn("Failed to fetch notifications");
    } finally {
      setLoading(false);
    }
  };

  const markAsViewed = async (id: number) => {
    const result = await markNotificationAsViewed(id);
    if (result) {
      setNotifications(
        notifications.map((notification) =>
          notification.id === id
            ? { ...notification, viewed: true }
            : notification
        )
      );
    }
  };

  const removeNotification = async (id: number) => {
    const success = await deleteNotification(id);
    if (success) {
      setNotifications(
        notifications.filter((notification) => notification.id !== id)
      );
    }
  };

  return (
    <NotificationContext.Provider
      value={{
        notifications,
        loading,
        fetchNotifications,
        markAsViewed,
        removeNotification,
      }}
    >
      {children}
    </NotificationContext.Provider>
  );
};
