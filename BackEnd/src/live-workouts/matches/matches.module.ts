import { Module } from '@nestjs/common';
import { MatchesService } from './matches.service';
import { MatchesController } from './matches.controller';
import { JwtModule } from '@nestjs/jwt';
import { UsersModule } from '../../users/users.module';
import { ProfilesModule } from '../../profiles/profiles.module';
import { AuthService } from '../../auth/auth.service';

@Module({
  imports: [
    JwtModule.register({}),
    UsersModule,
    ProfilesModule,
  ],
  controllers: [MatchesController],
  providers: [MatchesService, AuthService],
})
export class MatchesModule {}
