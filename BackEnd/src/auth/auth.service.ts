import { Redis } from 'ioredis';
import { AuthAppleService } from './auth-apple.service';
import { Inject, Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ProfilesService } from '../profiles/profiles.service';
import { UsersService } from '../users/users.service';
import { SignupDto } from './dto/signup.dto';
import { v4 as uuidv4 } from 'uuid';
import {
  InvalidTokenException,
  NicknameDuplicateException,
  NotRefreshTokenException,
} from './exceptions/auth.exception';
import * as process from 'process';
import { WetriWebSocket } from '../live-workouts/events/types/custom-websocket.type';
import { GetuserByUserIdAndProViderDto } from './dto/getUserByUserIdAndProvider.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly usersService: UsersService,
    private readonly profilesService: ProfilesService,
    private readonly authAppleService: AuthAppleService,
    @Inject('DATA_REDIS') private readonly redisData: Redis,
  ) {}

  signToken(publicId: string, isRefreshToken: boolean) {
    const payload = {
      sub: publicId,
      type: isRefreshToken ? 'refresh' : 'access',
    };

    return this.jwtService.sign(payload, {
      secret: process.env.JWT_SECRET,
      expiresIn: isRefreshToken
        ? parseInt(process.env.JWT_REFRESH_CYCLE)
        : parseInt(process.env.JWT_ACCESS_CYCLE),
    });
  }

  loginUser(publicId: string) {
    return {
      accessToken: this.signToken(publicId, false),
      refreshToken: this.signToken(publicId, true),
    };
  }

  async registerWithUserIdAndProvider(signupInfo: SignupDto) {
    if (
      await this.profilesService.validateProfileNickname(signupInfo.nickname)
    ) {
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

  async verifyWs(authorization: string, client: WetriWebSocket) {
    if (!authorization) {
      return false;
    }

    const token = this.extractTokenFromHeader(authorization);
    const decoded = await this.verifyToken(token);

    if (!decoded) {
      return false;
    }

    const profile = await this.profilesService.getProfile(decoded.sub);

    if (!profile) {
      return false;
    }

    client.id = profile.publicId;
    client.profile = profile;
    client.token = token;
    client.tokenType = decoded.type;

    return true;
  }

  verifyToken(token: string) {
    try {
      return this.jwtService.verify(token, {
        secret: process.env.JWT_SECRET,
      });
    } catch (error) {
      throw new InvalidTokenException();
    }
  }

  rotateToken(token: string, isRefreshToken: boolean) {
    const decoded = this.verifyToken(token);
    if (decoded.type !== 'refresh') {
      throw new NotRefreshTokenException();
    }

    return this.signToken(decoded.sub, isRefreshToken);
  }

  async checkSignUp(userId: string) {
    const userInfo: GetuserByUserIdAndProViderDto = {
      userId,
      provider: 'apple',
    };
    const user = this.usersService.getUserByUserIdAndProvider(userInfo);
    return user;
  }

  async appleSignIn(token: string) {
    const userId = await this.authAppleService.getAppleSub(token);
    const user = await this.checkSignUp(userId);
    if (!user) {
      const mappedUserID = uuidv4();
      await this.redisData.set(mappedUserID, userId);
      await this.redisData.expire(mappedUserID, 600);
      return {
        isFirstLogined: true,
        mappedUserID,
        provider: 'apple',
      };
    } else {
      return this.loginUser(user.profile.publicId);
    }
  }
}
