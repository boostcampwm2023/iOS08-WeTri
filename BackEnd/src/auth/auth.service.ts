import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ProfileModel } from 'src/profiles/entities/profiles.entity';
import { UserModel } from 'src/users/entities/users.entity';

@Injectable()
export class AuthService {
    constructor(
        private readonly jwtService: JwtService,
    ){}

    signToken(publicId: Pick<ProfileModel, 'publicId'>, isRefreshToken: boolean) {
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

    loginUser(publicId: Pick<ProfileModel, 'publicId'>) {
        return {
            accessToken: this.signToken(publicId, false),
            refreshToken: this.signToken(publicId, true),
        }
    }

    authenticateWithUserIdAndProvider(user: Pick<UserModel, 'userId' | 'provider'>) {
        
    }
}
