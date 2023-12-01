import { ApiProperty, PickType } from '@nestjs/swagger';
import { SuccessResDto } from 'src/common/dto/SuccessRes.dto';

class Token {
  @ApiProperty({
    example: 'ewaf1313RWDFA...',
    description: 'Access Token 입니다.',
  })
  accessToken: string;

  @ApiProperty({
    example: 'ewaf1313RWDFdddA...',
    description: 'Refresh Token 입니다.',
  })
  refreshToken: string;
}

class AccessToken extends PickType(Token, ['accessToken']) {}

class RefreshToken extends PickType(Token, ['refreshToken']) {}

export class SignupResDto extends SuccessResDto {
  @ApiProperty({ type: () => Token })
  data: Token;
}

export class CreateAccessTokenResDto extends SuccessResDto {
  @ApiProperty({ type: () => AccessToken })
  data: AccessToken;
}

export class CreateRefreshTokenResDto extends SuccessResDto {
  @ApiProperty({ type: () => RefreshToken })
  data: RefreshToken;
}
