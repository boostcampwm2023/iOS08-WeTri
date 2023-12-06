import { ApiProperty, PickType } from '@nestjs/swagger';
import { SuccessResDto } from '../../common/dto/SuccessRes.dto';
import { Post } from '../entities/posts.entity';
import { Record } from '../../records/entities/records.entity';
import { Profile } from '../../profiles/entities/profiles.entity';

class PostRecordDto extends PickType(Record, [
  'id',
  'workoutTime',
  'distance',
  'calorie',
  'avgHeartRate',
  'minHeartRate',
  'maxHeartRate',
]) {}

class PostProfileDto extends PickType(Profile, ['nickname']) {}

export class PostDto extends PickType(Post, [
  'id',
  'publicId',
  'content',
  'like',
  'createdAt',
  'updatedAt',
  'deletedAt',
  'postUrl',
]) {
  @ApiProperty({ type: () => PostRecordDto })
  record: PostRecordDto;

  @ApiProperty({ type: () => PostProfileDto })
  profile: PostProfileDto;
}

export class MetaDataDto {
  @ApiProperty({
    example: 5,
    description:
      'lastItem의 id를 의미합니다. (where__is__less_then, where__is__more_then의 value 값으로 그대로 넣으시면 됩니다.) 아이템이 없으면 null이 들어옵니다.',
  })
  lastItemId: number;

  @ApiProperty({
    example: false,
    description: '마지막 커서가 아니라면 false, 마지막 커서라면 true',
  })
  isLastCursor: boolean;

  @ApiProperty({
    example: 10,
    description: 'item의 개수를 의미합니다.',
  })
  count: number;
}

class PostsPaginateResDto {
  @ApiProperty({ type: () => [PostDto] })
  items: PostDto[];

  @ApiProperty({ type: () => MetaDataDto })
  metaData: MetaDataDto;
}

export class GetPostsResponseDto extends SuccessResDto {
  @ApiProperty({ type: () => PostsPaginateResDto })
  data: PostsPaginateResDto;
}
