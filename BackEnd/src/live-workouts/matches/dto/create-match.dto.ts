import { IsNotEmpty, IsNumber } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { SuccessResDto } from '../../../common/dto/SuccessRes.dto';

export class CreateMatchDto {
  @IsNumber()
  @IsNotEmpty()
  @ApiProperty({ example: 1 })
  workoutId: number;
}
