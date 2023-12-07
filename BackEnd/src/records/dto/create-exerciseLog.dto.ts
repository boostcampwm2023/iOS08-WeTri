import { ApiProperty, PickType } from '@nestjs/swagger';
import { Record } from '../entities/records.entity';
import { IsNumber } from 'class-validator';

export class CreateExerciseLogDto extends PickType(Record, [
  'workoutTime',
  'calorie',
  'distance',
  'avgHeartRate',
  'maxHeartRate',
  'minHeartRate',
  'mapCapture',
  'gps'
]) {
  @ApiProperty({
    example: 1,
    description: '운동 종류 ID입니다.',
  })
  @IsNumber()
  workoutId: number;
}
