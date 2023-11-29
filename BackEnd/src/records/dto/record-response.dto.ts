import { ApiProperty, PickType } from '@nestjs/swagger';
import { SuccessResDto } from 'src/common/dto/SuccessRes.dto';
import { Record } from '../entities/records.entity';

class GetRecord extends PickType(Record, [
  'id',
  'workout',
  'profile',
  'workoutTime',
  'distance',
  'calorie',
  'avgHeartRate',
  'minHeartRate',
  'maxHeartRate',
  'createdAt',
]) {}

export class CreateRecordResDto extends SuccessResDto {
  @ApiProperty({ type: () => Record })
  data: Pick<Record, 'id'>;
}

export class GetUsersRecordsResDto extends SuccessResDto {
  @ApiProperty({ type: () => [GetRecord] })
  data: GetRecord[];
}

export class GetRecordResDto extends SuccessResDto {
  @ApiProperty({ type: () => GetRecord })
  data: GetRecord;
}
