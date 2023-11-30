import { Module } from '@nestjs/common';
import { ImagesController } from './images.controller';
import { ImagesService } from './images.service';
import {AuthModule} from "../auth/auth.module";
import {ProfilesModule} from "../profiles/profiles.module";

@Module({
  imports: [AuthModule, ProfilesModule],
  controllers: [ImagesController],
  providers: [ImagesService],
})
export class ImagesModule {}
