import { Profile } from '../entities/profiles.entity';
import { ApiProperty, IntersectionType, PickType } from '@nestjs/swagger';
import { SuccessResDto } from '../../common/dto/SuccessRes.dto';
import { Post } from '../../posts/entities/posts.entity';

export class GetResPostUrl extends PickType(Post, ['id', 'postUrl']) {}

class GetResProfile extends PickType(Profile, [
  'nickname',
  'gender',
  'birthdate',
  'publicId',
  'profileImage',
]) {}

class Intersection extends IntersectionType(GetResProfile, GetResPostUrl) {}

export class GetResProfileDto extends SuccessResDto {
  @ApiProperty({ type: () => Intersection })
  data: Intersection;
}
