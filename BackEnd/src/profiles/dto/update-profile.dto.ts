import { PickType } from '@nestjs/swagger';
import { Profile } from '../entities/profiles.entity';

export class UpdateProfileDto extends PickType(Profile, [
  'nickname',
  'profileImage',
]) {}
