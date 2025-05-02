import { GoalType } from '@prisma/client';
import {
  IsNotEmpty,
  IsInt,
  IsString,
  IsDateString,
  IsBoolean,
  Validate,
} from 'class-validator';

export class GoalDTO {
  @IsNotEmpty()
  @IsInt()
  targetAmount: number;

  @IsNotEmpty()
  @IsString()
  type: GoalType;

  @IsNotEmpty()
  @IsDateString()
  startDate: Date;

  @IsNotEmpty()
  @IsDateString()
  endDate: Date;

  @IsBoolean()
  allowNotifications: boolean = true;

  @IsString()
  @Validate((value) => {
    const [hours, minutes] = value.split(':').map(Number);
    if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
      return false;
    }
    return true;
  })
  notificationTime: string;
}

export class GoalUpdateDTO {
  @IsInt()
  amountRead: number;

  @IsBoolean()
  allowNotifications: boolean = true;
}
