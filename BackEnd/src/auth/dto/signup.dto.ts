import { IntersectionType, PickType } from '@nestjs/swagger';
import { ProfileModel } from '../../profiles/entities/profiles.entity';
import { UserModel } from '../../users/entities/users.entity';

class UserDto extends PickType(UserModel, ['userId', 'provider']) {}
class ProfileDto extends PickType(ProfileModel, [
  'nickname',
  'gender',
  'birthdate',
]) {}

export class SignupDto extends IntersectionType(UserDto, ProfileDto) {}
