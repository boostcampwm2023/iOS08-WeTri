import { PickType } from '@nestjs/swagger';
import { Post } from '../entities/posts.entity';

export class UpdatePostDto extends PickType(Post, ['content', 'postUrl']) {}
