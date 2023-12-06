import { ApiProperty, PickType } from '@nestjs/swagger';
import { SuccessResDto } from '../common/dto/SuccessRes.dto';
import { MetaDataDto } from '../posts/dto/get-posts-response.dto';
import { Post } from '../posts/entities/posts.entity';

export class ItemDto extends PickType(Post, ['id', 'postUrl']) {}

class ProfilePostsPaginateResDto {
  @ApiProperty({ type: () => [ItemDto] })
  item: ItemDto[];

  @ApiProperty({ type: () => MetaDataDto })
  metaData: MetaDataDto;
}

export class GetProfilePostsResponseDto extends SuccessResDto {
  @ApiProperty({ type: () => ProfilePostsPaginateResDto })
  data: ProfilePostsPaginateResDto;
}
