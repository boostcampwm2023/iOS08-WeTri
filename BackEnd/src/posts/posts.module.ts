import { Module } from '@nestjs/common';
import { PostsService } from './posts.service';
import { PostsController } from './posts.controller';
import { AuthModule } from 'src/auth/auth.module';
import { ProfilesModule } from 'src/profiles/profiles.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Post } from './entities/posts.entity';
import { RecordsModule } from 'src/records/records.module';

@Module({
  imports: [TypeOrmModule.forFeature([Post]), AuthModule, ProfilesModule, RecordsModule],
  controllers: [PostsController],
  providers: [PostsService],
})
export class PostsModule {}
