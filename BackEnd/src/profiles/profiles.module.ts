import { Module } from '@nestjs/common';
import { ProfilesService } from './profiles.service';
import { ProfilesController } from './profiles.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Profile } from './entities/profiles.entity';
import { Post } from '../posts/entities/posts.entity';
import { AuthService } from '../auth/auth.service';
import { JwtModule } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import { AuthAppleService } from '../auth/auth-apple.service';
import { User } from '../users/entities/users.entity';
import { CommonModule } from '../common/common.module';
@Module({
  imports: [
    TypeOrmModule.forFeature([Profile, Post, User]),
    JwtModule.register({}),
    CommonModule,
  ],
  exports: [ProfilesService],
  controllers: [ProfilesController],
  providers: [ProfilesService, AuthService, UsersService, AuthAppleService],
})
export class ProfilesModule {}
