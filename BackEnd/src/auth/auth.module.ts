import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtModule } from '@nestjs/jwt';
import { UsersModule } from '../users/users.module';
import { ProfilesModule } from '../profiles/profiles.module';

@Module({
  imports: [JwtModule.register({}), UsersModule, ProfilesModule],
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}
