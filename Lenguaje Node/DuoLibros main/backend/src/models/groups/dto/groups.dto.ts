import { IsNotEmpty, IsString } from 'class-validator';

export class GroupDTO {
  @IsNotEmpty()
  @IsString()
  name: string;

  @IsNotEmpty()
  @IsString()
  description: string;
}

export class GroupUpdateDTO {
  @IsString()
  name: string;

  @IsString()
  description: string;
}
