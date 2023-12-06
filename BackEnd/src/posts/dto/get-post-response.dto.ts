import { SuccessResDto } from 'src/common/dto/SuccessRes.dto';
import { ApiProperty } from '@nestjs/swagger';
import { PostDto } from './get-posts-response.dto';

export class GetPostResponseDto extends SuccessResDto {
  @ApiProperty({ type: () => PostDto })
  data: PostDto;
}
