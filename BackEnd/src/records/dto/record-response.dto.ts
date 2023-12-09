import { ApiProperty, PickType } from '@nestjs/swagger';
import { SuccessResDto } from '../../common/dto/SuccessRes.dto';
import { Record } from '../entities/records.entity';
import { Workout } from 'src/workouts/entities/workout.entity';
class WorkoutDto extends PickType(Workout, ['name']) {}
class GetRecord extends PickType(Record, [
  'profile',
  'workoutTime',
  'distance',
  'calorie',
  'avgHeartRate',
  'minHeartRate',
  'maxHeartRate',
  'createdAt',
  'mapCapture',
  'gps'
]) {
  @ApiProperty( {type: () => WorkoutDto} )
  workout: WorkoutDto;
}
class GetRecordWithId extends PickType(Record, ['id']) {}
export class CreateRecordResDto extends SuccessResDto {
  @ApiProperty({ type: () => GetRecordWithId })
  data: Pick<GetRecordWithId, 'id'>;
}
export class GetUsersRecordsResDto extends SuccessResDto {
  @ApiProperty({ type: () => [GetRecord] })
  data: GetRecord[];
}
export class GetRecordResDto extends SuccessResDto {
  @ApiProperty({ type: () => GetRecord })
  data: GetRecord;
}