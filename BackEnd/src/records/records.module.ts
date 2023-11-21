import { Module } from '@nestjs/common';
import { RecordsService } from './records.service';
import { RecordsController } from './records.controller';
import { AuthModule } from 'src/auth/auth.module';
import { ProfilesModule } from 'src/profiles/profiles.module';

@Module({
  imports: [AuthModule, ProfilesModule],
  controllers: [RecordsController],
  providers: [RecordsService],
})
export class RecordsModule {}
