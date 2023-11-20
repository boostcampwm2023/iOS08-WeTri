import { Module } from '@nestjs/common';
import { ProfilesService } from './profiles.service';
import { ProfilesController } from './profiles.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProfileModel } from './entities/profiles.entity';

@Module({
  imports: [TypeOrmModule.forFeature([ProfileModel])],
  exports: [ProfilesService],
  controllers: [ProfilesController],
  providers: [ProfilesService],
})
export class ProfilesModule {}
