import { NotificationProvider } from "../contexts/NotificationContext";
import NotificationOverview from "../components/Notifications/Notificator";

export default function NotificationPage() {
  return (
    <NotificationProvider>
      <div>
        <NotificationOverview />
      </div>
    </NotificationProvider>
  );
}
