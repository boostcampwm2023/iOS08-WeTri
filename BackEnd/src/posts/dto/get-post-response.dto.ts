import { SuccessResDto } from '../../common/dto/SuccessRes.dto';
import { ApiProperty } from '@nestjs/swagger';
import { ItemDto } from './get-posts-response.dto';

export class GetPostResponseDto extends SuccessResDto {
  @ApiProperty({ type: () => ItemDto })
  data: ItemDto;
}
