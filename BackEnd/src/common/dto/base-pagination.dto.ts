import { ApiProperty } from '@nestjs/swagger';
import { IsIn, IsNumber, IsOptional } from 'class-validator';

export class BasePaginationDto {
  @ApiProperty({
    example: 5,
    description: 'id값보다 낮은 아이템을 가져옵니다.',
    required: false,
  })
  @IsOptional()
  @IsNumber()
  where__id__less_then?: number;

  @ApiProperty({
    example: 5,
    description: 'id값보다 높은 아이템을 가져옵니다.',
    required: false,
  })
  @IsOptional()
  @IsNumber()
  where__id__more_then?: number;

  @ApiProperty({
    example: 'ASC | DESC',
    description: 'createdAt을 기준으로 정렬합니다.',
    required: false,
  })
  @IsOptional()
  @IsIn(['ASC', 'DESC'])
  order__createdAt: 'ASC' | 'DESC' = 'DESC';

  @ApiProperty({
    example: 5,
    description: '가져올 아이템 수를 의미합니다.',
    required: false,
  })
  @IsOptional()
  @IsNumber()
  take: number = 15;
}
