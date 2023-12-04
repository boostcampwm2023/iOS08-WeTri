import { ApiProperty, PickType } from '@nestjs/swagger';
import { SuccessResDto } from 'src/common/dto/SuccessRes.dto';
import { Post } from '../entities/posts.entity';

export class ItemDto extends PickType(Post, [
  'id',
  'publicId',
  'content',
  'like',
  'createdAt',
  'updatedAt',
  'deletedAt',
  'postUrl',
]) {}

class MetaDataDto {
  @ApiProperty({
    example: 5,
    description: 'lastItem의 id를 의미합니다.',
  })
  after: number;

  @ApiProperty({
    example: 10,
    description: 'item의 개수를 의미합니다.',
  })
  count: number;
}

class PostsPaginateResDto {
  @ApiProperty({ type: () => [ItemDto] })
  items: ItemDto[];

  @ApiProperty({ type: () => MetaDataDto })
  metaData: MetaDataDto;
}

export class GetPostsResponseDto extends SuccessResDto {
  @ApiProperty({ type: () => PostsPaginateResDto })
  data: PostsPaginateResDto;
}
