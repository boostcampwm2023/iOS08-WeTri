import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { AuthService } from '../auth.service';
import { ProfilesService } from '../../profiles/profiles.service';
import { NotAccessTokenException, NotExistToken, NotRefreshTokenException } from '../exceptions/auth.exception';

@Injectable()
export class BearerTokenGuard implements CanActivate {
  constructor(
    private readonly authService: AuthService,
    private readonly profilesService: ProfilesService,
  ) {}
  async canActivate(context: ExecutionContext): Promise<boolean> {
    const req = context.switchToHttp().getRequest();

    const rawToken = req.headers['authorization'];

    if (!rawToken) {
      throw new NotExistToken();
    }

    const token = this.authService.extractTokenFromHeader(rawToken);

    const decoded = await this.authService.verifyToken(token);

    const profile = await this.profilesService.findByPublicId(decoded.sub);

    const type = decoded.type;

    req.profile = profile;
    req.token = token;
    req.tokenType = type;

    return true;
  }
}

@Injectable()
export class AccessTokenGuard extends BearerTokenGuard {
  async canActivate(context: ExecutionContext): Promise<boolean> {
    await super.canActivate(context);

    const req = context.switchToHttp().getRequest();

    if (req.tokenType !== 'access') {
      throw new NotAccessTokenException();
    }

    return true;
  }
}

@Injectable()
export class RefreshTokenGuard extends BearerTokenGuard {
  async canActivate(context: ExecutionContext): Promise<boolean> {
    await super.canActivate(context);

    const req = context.switchToHttp().getRequest();

    if (req.tokenType !== 'refresh') {
      throw new NotRefreshTokenException();
    }

    return true;
  }
}
