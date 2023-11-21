import { PickType } from '@nestjs/swagger';
import { RecordModel } from '../entities/records.entity';

export class CreateExerciseLogDto extends PickType(RecordModel, [
  'workout',
  'runningTime',
  'distance',
  'avgBpm',
  'minBpm',
  'maxBpm',
]) {}
