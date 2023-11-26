import { IsNotEmpty, IsNumber } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
export class CreateMatchDto {
  @IsNumber()
  @IsNotEmpty()
  @ApiProperty({ example: 1 })
  workoutId: number;
}
