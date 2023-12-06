import { Module } from '@nestjs/common';
import { MatchesService } from './matches.service';
import { MatchesController } from './matches.controller';
import { JwtModule } from '@nestjs/jwt';
import { UsersModule } from '../../users/users.module';
import { ProfilesModule } from '../../profiles/profiles.module';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [JwtModule.register({}), UsersModule, ProfilesModule, AuthModule],
  controllers: [MatchesController],
  providers: [MatchesService],
})
export class MatchesModule {}
