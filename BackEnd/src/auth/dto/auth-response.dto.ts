import { ApiProperty, PickType } from '@nestjs/swagger';
import { SuccessResDto } from 'src/common/dto/SuccessRes.dto';

class Token {
  @ApiProperty({
    example: 'ewaf1313RWDFA...',
    description: 'Access Token 입니다.',
  })
  accessToken: string;

  @ApiProperty({
    example: 'ewaf1313RWDFA...',
    description: 'Refresh Token 입니다.',
  })
  refreshToken: string;
}

export class SignupResDto extends SuccessResDto {
  @ApiProperty({ type: () => Token })
  data: Token;
}

export class CreateAccessTokenResDto extends SuccessResDto {
  @ApiProperty({ type: () => PickType(Token, ['accessToken']) })
  data: Pick<Token, 'accessToken'>;
}

export class CreateRefreshTokenResDto extends SuccessResDto {
  @ApiProperty({ type: () => PickType(Token, ['refreshToken']) })
  data: Pick<Token, 'refreshToken'>;
}
