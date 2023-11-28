import { Body, Controller, Headers, Post, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RefreshTokenGuard } from './guard/bearerToken.guard';
import { SignupDto } from './dto/signup.dto';
import { AuthAppleService } from './auth-apple.service';
import { AppleToken } from './decorator/apple-token.decorator';
import { ApiBody, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import {
  CreateAccessTokenResDto,
  CreateRefreshTokenResDto,
  SignupResDto,
} from './dto/auth-response.dto';

@ApiTags('Authentication')
@Controller('api/v1/auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly authAppleService: AuthAppleService,
  ) {}

  @ApiOperation({ summary: '유저 회원가입' })
  @ApiBody({ description: 'The ID of the item', type: SignupDto })
  @ApiResponse({
    status: 200,
    description: '회원가입 성공',
    type: SignupResDto,
  })
  @ApiResponse({ status: 400, description: 'Bad request' })
  @Post('signup')
  signup(@Body() body: SignupDto) {
    return this.authService.registerWithUserIdAndProvider(body);
  }

  @ApiOperation({ summary: 'Access token 생성' })
  @ApiResponse({
    status: 200,
    description: '토큰 생성 성공',
    type: CreateAccessTokenResDto,
  })
  @ApiResponse({ status: 400, description: 'Bad request' })
  @Post('token/access')
  @UseGuards(RefreshTokenGuard)
  tokenAccess(@Headers('authorization') raw: string) {
    const token = this.authService.extractTokenFromHeader(raw);

    const newToken = this.authService.rotateToken(token, false);

    return {
      accessToken: newToken,
    };
  }

  @ApiOperation({ summary: 'Refresh token 생성' })
  @ApiResponse({
    status: 200,
    description: '토큰 생성 성공',
    type: CreateRefreshTokenResDto,
  })
  @ApiResponse({ status: 400, description: 'Bad request' })
  @Post('token/refresh')
  @UseGuards(RefreshTokenGuard)
  tokenRefresh(@Headers('authorization') raw: string) {
    const token = this.authService.extractTokenFromHeader(raw);

    const newToken = this.authService.rotateToken(token, true);

    return {
      refreshToken: newToken,
    };
  }

  @ApiOperation({ summary: '유저 애플 로그인' })
  @ApiResponse({ status: 200, description: '로그인 성공' })
  @ApiResponse({ status: 400, description: 'Bad request' })
  @Post('apple/signin')
  async appleSignIn(@AppleToken() token: string) {
    const userInfo = await this.authAppleService.getUserInfo(token);
    console.log(userInfo);
  }
}
