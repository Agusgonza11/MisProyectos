/*
  Warnings:

  - You are about to drop the column `lastNotification` on the `Goal` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Goal" DROP COLUMN "lastNotification",
ADD COLUMN     "notificationTimeHour" INTEGER NOT NULL DEFAULT 9,
ADD COLUMN     "notificationTimeMinutes" INTEGER NOT NULL DEFAULT 0;
