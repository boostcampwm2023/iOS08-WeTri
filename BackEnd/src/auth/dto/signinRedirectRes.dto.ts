import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';
import { SuccessResDto } from '../common/dto/SuccessRes.dto';

class SigninFirstRes {
  @ApiProperty({
    example: true,
    description: '첫 로그인이면 true',
  })
  @IsString()
  isFirstLogined: boolean;

  @ApiProperty({
    example: '1233498sdafksdjhfk...',
    description:
      'mappedUserID -> 애플리케이션에서 고유한 apple id를 매핑한 uuid',
  })
  @IsString()
  mappedUserID: string;

  @ApiProperty({
    example: 'apple',
    description: '로그인 플랫폼',
  })
  @IsString()
  provider: string;
}

export class SigninFirstResDto extends SuccessResDto {
  @ApiProperty({ type: () => SigninFirstRes })
  data: SigninFirstRes;
}
