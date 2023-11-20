import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('signup')
  signup(
    @Body('userId') userId: string,
    @Body('provider') provider: string,
    @Body('nickname') nickname: string,
    @Body('gender') gender: string,
    @Body('birthdate') birthdate: Date,
  ) {
    return this.authService.registerWithUserIdAndProvider({
      userId,
      provider
    }, {
      nickname,
      gender,
      birthdate,
    });
  }
}
