import React, { useContext, useEffect, useState } from "react";
import {
  Badge,
  Box,
  CircularProgress,
  IconButton,
  List,
  ListItem,
  ListItemText,
  Popover,
  Typography,
} from "@mui/material";
import NotificationsIcon from "@mui/icons-material/Notifications";
import VisibilityIcon from "@mui/icons-material/Visibility";
import DeleteIcon from "@mui/icons-material/Delete";
import { NotificationContext } from "../../contexts/NotificationContext";

export default function NotificationOverview() {
  const notificationContext = useContext(NotificationContext);
  const {
    notifications,
    loading,
    fetchNotifications,
    markAsViewed,
    removeNotification,
  } = notificationContext;
  const [anchorEl, setAnchorEl] = useState<HTMLButtonElement | null>(null);

  useEffect(() => {
    fetchNotifications();
  }, []);

  const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    setAnchorEl(event.currentTarget);
  };

  const handleClose = () => {
    setAnchorEl(null);
  };

  const notViewedNotificationCount = notifications.filter(
    (notification) => !notification.viewed
  ).length;

  const open = Boolean(anchorEl);
  const id = open ? "notification-popover" : undefined;

  return (
    <Box>
      <IconButton onClick={handleClick} size="large">
        <Badge badgeContent={notViewedNotificationCount} color="error">
          <NotificationsIcon sx={{ color: "white" }} />
        </Badge>
      </IconButton>
      <Popover
        id={id}
        open={open}
        anchorEl={anchorEl}
        onClose={handleClose}
        anchorOrigin={{
          vertical: "bottom",
          horizontal: "right",
        }}
        transformOrigin={{
          vertical: "top",
          horizontal: "right",
        }}
      >
        <Box sx={{ p: 2, width: 450, maxHeight: 600, overflow: "auto" }}>
          <Typography variant="h6" gutterBottom margin={1}>
            Notifications
          </Typography>
          {loading ? (
            <Box display="flex" justifyContent="center" my={2}>
              <CircularProgress />
            </Box>
          ) : notifications.length > 0 ? (
            <List>
              {notifications.map((notification) => (
                <ListItem
                  key={notification.id}
                  secondaryAction={
                    <Box display="flex" flex={1} sx={{ gap: 2 }}>
                      <IconButton
                        edge="end"
                        aria-label="mark as read"
                        onClick={() => markAsViewed(notification.id)}
                      >
                        <VisibilityIcon />
                      </IconButton>
                      <IconButton
                        edge="end"
                        aria-label="delete"
                        onClick={() => removeNotification(notification.id)}
                      >
                        <DeleteIcon />
                      </IconButton>
                    </Box>
                  }
                  sx={{
                    bgcolor: notification.viewed
                      ? "transparent"
                      : "action.hover",
                    borderRadius: 2,
                  }}
                >
                  <ListItemText
                    primary={notification.message}
                    secondary={new Date(
                      notification.createdAt
                    ).toLocaleString()}
                    sx={{ flex: 1, maxWidth: 300 }}
                  />
                </ListItem>
              ))}
            </List>
          ) : (
            <Typography margin={1} color="gray">
              No hay notificaciones
            </Typography>
          )}
        </Box>
      </Popover>
    </Box>
  );
}
