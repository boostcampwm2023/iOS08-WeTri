import { Body, Controller, Headers, Post, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RefreshTokenGuard } from './guard/bearerToken.guard';
import { SignupDto } from './dto/signup.dto';

@Controller('api/v1/auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('signup')
  signup(@Body() body: SignupDto) {
    return this.authService.registerWithUserIdAndProvider(body);
  }

  @Post('token/access')
  @UseGuards(RefreshTokenGuard)
  tokenAccess(@Headers('authorization') raw: string) {
    const token = this.authService.extractTokenFromHeader(raw);

    const newToken = this.authService.rotateToken(token, false);

    return {
      accessToken: newToken,
    };
  }

  @Post('token/access')
  @UseGuards(RefreshTokenGuard)
  tokenRefresh(@Headers('authorization') raw: string) {
    const token = this.authService.extractTokenFromHeader(raw);

    const newToken = this.authService.rotateToken(token, true);

    return {
      refreshToken: newToken,
    };
  }
}
