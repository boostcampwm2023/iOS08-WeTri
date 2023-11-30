import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class SignInDto {
  @ApiProperty({
    example: '23432USDFAS2134AD...',
    description: 'Identity token',
  })
  @IsString()
  identityToken: string;

  @ApiProperty({
    example: '23432USDFAS2134AD...',
    description: 'Authorization Code',
  })
  @IsString()
  authorizationCode: string;
}
