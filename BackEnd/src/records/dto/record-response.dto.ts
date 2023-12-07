import { ApiProperty, PickType } from '@nestjs/swagger';
import { SuccessResDto } from '../../common/dto/SuccessRes.dto';
import { Record } from '../entities/records.entity';

class GetRecord extends PickType(Record, [
  'workout',
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
]) {}

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
