import { IntersectionType, PickType } from '@nestjs/swagger';
import { Profile } from '../../profiles/entities/profiles.entity';
import { User } from '../../users/entities/users.entity';

class UserDto extends PickType(User, ['userId', 'provider']) {}
class ProfileDto extends PickType(Profile, [
  'nickname',
  'gender',
  'birthdate',
]) {}

export class SignupDto extends IntersectionType(UserDto, ProfileDto) {}
