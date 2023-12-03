import { Module } from '@nestjs/common';
import { ProfilesService } from './profiles.service';
import { ProfilesController } from './profiles.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Profile } from './entities/profiles.entity';
@Module({
  imports: [TypeOrmModule.forFeature([Profile])],
  exports: [ProfilesService],
  controllers: [ProfilesController],
  providers: [ProfilesService],
})
export class ProfilesModule {}
