import { ApiProperty, PickType } from '@nestjs/swagger';
import { Post } from '../entities/posts.entity';
import { IsNumber } from 'class-validator';

export class CreatePostDto extends PickType(Post, ['content', 'imagesUrl']) {
  @ApiProperty({
    example: 1,
    description: 'recordId를 뜻합니다.',
  })
  @IsNumber()
  recordId: number;
}
