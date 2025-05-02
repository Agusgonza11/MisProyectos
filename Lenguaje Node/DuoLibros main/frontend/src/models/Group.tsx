import { UserEntity } from "./UserEntity";

export type Group = {
  id: number;
  name: string;
  description: string;
  createdBy: number;
  createdAt: string;
  updatedAt: string;
  members: Member[];
};

export enum UserRole {
  OWNER = "OWNER",
  MEMBER = "MEMBER",
}

export type Member = {
  id: number;
  userId: number;
  groupId: number;
  joinedAt: string;
  user: UserEntity;
};
