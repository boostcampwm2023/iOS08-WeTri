import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ProfilesService } from '../profiles/profiles.service';
import { UserModel } from '../users/entities/users.entity';
import { UsersService } from '../users/users.service';
import { SignupDto } from './dto/signup.dto';
import {
  InvalidTokenException,
  NicknameDuplicateException,
  NotRefreshTokenException,
} from './exceptions/auth.exception';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly usersService: UsersService,
    private readonly profilesService: ProfilesService,
  ) {}

  signToken(publicId: string, isRefreshToken: boolean) {
    //payload에는 sub -> id가 들어감 (사용자를 고유하게 식별하는데 사용), type (access token, refresh token)
    const payload = {
      sub: publicId,
      type: isRefreshToken ? 'refresh' : 'access',
    };

    return this.jwtService.sign(payload, {
      secret: process.env.JWT_SECRET,
      expiresIn: isRefreshToken ? 86400 : 3600,
    });
  }

  loginUser(publicId: string) {
    return {
      accessToken: this.signToken(publicId, false),
      refreshToken: this.signToken(publicId, true),
    };
  }

  async authenticateWithUserIdAndProvider(
    user: Pick<UserModel, 'userId' | 'provider'>,
  ) {
    const existingUser =
      await this.usersService.getUserByUserIdAndProvider(user);

    if (!existingUser) {
      //   throw new UnauthorizedException('존재하지 않는 사용자입니다.');
      console.log('회원가입 페이지로 리디렉션');
    }

    return existingUser;
  }

  async registerWithUserIdAndProvider(signupInfo: SignupDto) {
    if (await this.profilesService.existByNickname(signupInfo.nickname)) {
      //   throw new BadRequestException('중복된 nickname 입니다.');
      throw new NicknameDuplicateException();
    }
    const newUser = await this.usersService.createUser(signupInfo);

    return this.loginUser(newUser.profile.publicId);
  }

  extractTokenFromHeader(header: string) {
    const splitToken = header.split(' ');

    const type = splitToken[0];

    if (splitToken.length !== 2 || type !== 'Bearer') {
      throw new InvalidTokenException();
    }

    const token = splitToken[1];

    return token;
  }

  verifyToken(token: string) {
    return this.jwtService.verify(token, {
      secret: process.env.JWT_SECRET,
    });
  }

  rotateToken(token: string, isRefreshToken: boolean) {
    const decoded = this.verifyToken(token);
    if (decoded.type !== 'refresh') {
      throw new NotRefreshTokenException();
    }

    return this.signToken(decoded.sub, isRefreshToken);
  }
}