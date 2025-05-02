export type Goal = {
  id: number;
  userId: number;
  type: string;
  targetAmount: number;
  amountRead: number;
  progress: number;
  startDate: string;
  endDate: string;
  completed: boolean;
  createdAt: string;
};

export type GoalData = {
  targetAmount: number;
  type: GoalTypes;
  startDate: string;
  endDate: string;
  notificationTime: string;
  allowNotifications: boolean;
};

export enum GoalTypes {
  Books = "BOOKS",
  Pages = "PAGES",
}

export const getGoalTypeText = (type: string) => {
  switch (type) {
    case GoalTypes.Books:
      return "Libros";
    case GoalTypes.Pages:
      return "Páginas";
    default:
      return "";
  }
};

export const getColorByGoalType = (type: string) => {
  switch (type) {
    case GoalTypes.Books:
      return "#9000c9";
    case GoalTypes.Pages:
      return "#ed6c02";
    default:
      return "";
  }
};
