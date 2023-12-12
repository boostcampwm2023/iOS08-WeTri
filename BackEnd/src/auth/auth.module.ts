import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtModule } from '@nestjs/jwt';
import { UsersModule } from '../users/users.module';
import { ProfilesModule } from '../profiles/profiles.module';
import { AuthAppleService } from './auth-apple.service';

@Module({
  imports: [JwtModule.register({}), UsersModule, ProfilesModule],
  exports: [AuthService, AuthAppleService],
  controllers: [AuthController],
  providers: [AuthService, AuthAppleService],
})
export class AuthModule {}
