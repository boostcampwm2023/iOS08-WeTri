import { ApiProperty, PickType } from '@nestjs/swagger';
import { SuccessResDto } from 'src/common/dto/SuccessRes.dto';
import { MetaDataDto } from 'src/posts/dto/get-posts-response.dto';
import { Post } from 'src/posts/entities/posts.entity';

export class ProfilePostDto extends PickType(Post, ['id', 'postUrl']) {}

class ProfilePostsPaginateResDto {
  @ApiProperty({ type: () => [ProfilePostDto] })
  item: ProfilePostDto[];

  @ApiProperty({ type: () => MetaDataDto })
  metaData: MetaDataDto;
}

export class GetProfilePostsResponseDto extends SuccessResDto {
  @ApiProperty({ type: () => ProfilePostsPaginateResDto })
  data: ProfilePostsPaginateResDto;
}
