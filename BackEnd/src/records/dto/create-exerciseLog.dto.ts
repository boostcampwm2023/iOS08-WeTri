import { PickType } from '@nestjs/swagger';
import { Record } from '../entities/records.entity';

export class CreateExerciseLogDto extends PickType(Record, [
  'workout',
  'workoutTime',
  'calorie',
  'distance',
  'avgHeartRate',
  'maxHeartRate',
  'minHeartRate',
]) {}
