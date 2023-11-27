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

class RecordIdDto {
  @ApiProperty({ example: 1, description: '운동 기록 레코드 ID' })
  recordId: number;
}

export class CreateRecordResDto extends SuccessResDto {
  @ApiProperty({ type: () => RecordIdDto })
  data: Pick<RecordIdDto, 'recordId'>;
}

export class GetUsersRecordsResDto extends SuccessResDto {
  @ApiProperty({ type: () => [GetRecord] })
  data: GetRecord[];
}

export class GetRecordResDto extends SuccessResDto {
  @ApiProperty({ type: () => GetRecord })
  data: GetRecord;
}
