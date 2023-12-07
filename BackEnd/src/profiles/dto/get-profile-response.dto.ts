import { ApiProperty, PickType } from '@nestjs/swagger';
import { Profile } from '../entities/profiles.entity';
import { SuccessResDto } from '../../common/dto/SuccessRes.dto';

class GetProfileDto extends PickType(Profile, [
  'nickname',
  'gender',
  'birthdate',
  'publicId',
  'profileImage',
]) {}

export class GetProfileResponseDto extends SuccessResDto {
  @ApiProperty({ type: () => GetProfileDto })
  data: GetProfileDto;
}
