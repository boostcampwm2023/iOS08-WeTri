import { PickType } from '@nestjs/swagger';
import { Record } from '../entities/records.entity';

export class CreateExerciseLogDto extends PickType(Record, [
  'id',
  'workoutTime',
  'calorie',
  'distance',
  'avgHeartRate',
  'maxHeartRate',
  'minHeartRate',
]) {}
