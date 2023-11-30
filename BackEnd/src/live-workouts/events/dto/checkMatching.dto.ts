import { IsString } from 'class-validator';

export class CheckMatchingDto {
  @IsString()
  matchingKey: string;

  @IsString()
  roomId: string;
}
