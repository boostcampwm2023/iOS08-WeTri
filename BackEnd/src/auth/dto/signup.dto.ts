import { ApiProperty, IntersectionType, PickType } from '@nestjs/swagger';
import { Profile } from '../../profiles/entities/profiles.entity';
import { User } from '../../users/entities/users.entity';
import { IsString } from 'class-validator';

class UserDto extends PickType(User, ['provider']) {}
class ProfileDto extends PickType(Profile, [
  'nickname',
  'gender',
  'birthdate',
]) {}

export class SignupDto extends IntersectionType(UserDto, ProfileDto) {
  @ApiProperty({
    example: 'WQRWR-214-SADF',
    description: 'userId를 매핑한 uuid입니다.',
  })
  @IsString()
  mappedUserID: string;
}
