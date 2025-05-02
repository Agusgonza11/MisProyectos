/*
  Warnings:

  - A unique constraint covering the columns `[userId,type,createdAt]` on the table `Goal` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Goal_userId_type_createdAt_key" ON "Goal"("userId", "type", "createdAt");
