import { BadRequestException, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ProfileModel } from 'src/profiles/entities/profiles.entity';
import { ProfilesService } from 'src/profiles/profiles.service';
import { UserModel } from 'src/users/entities/users.entity';
import { UsersService } from 'src/users/users.service';

@Injectable()
export class AuthService {
    constructor(
        private readonly jwtService: JwtService,
        private readonly usersService: UsersService,
        private readonly profilesService: ProfilesService,
    ){}

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
        }
    }

    async authenticateWithUserIdAndProvider(user: Pick<UserModel, 'userId' | 'provider'>) {
        const existingUser = await this.usersService.getUserByUserIdAndProvider(user);
        
        if(!existingUser) {
            throw new UnauthorizedException('존재하지 않는 사용자입니다.');
        }

        return existingUser
    }

    async registerWithUserIdAndProvider(user: Pick<UserModel, 'userId' | 'provider'>, profile: Pick<ProfileModel, 'nickname' | 'gender' | 'birthdate' | 'publicId'>) {
        if(this.profilesService.existByNickname(profile.nickname)) {
            throw new BadRequestException("중복된 nickname 입니다.")
        }
        const newUser = await this.usersService.createUser(user, profile);
        
        return this.loginUser(newUser.profile.publicId);
    }
}
