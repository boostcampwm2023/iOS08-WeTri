import { Module } from '@nestjs/common';
import { RecordsService } from './records.service';
import { RecordsController } from './records.controller';
import { AuthModule } from '../auth/auth.module';
import { ProfilesModule } from '../profiles/profiles.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Record } from './entities/records.entity';
import { WorkoutsModule } from '../workouts/workouts.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Record]),
    AuthModule,
    ProfilesModule,
    WorkoutsModule,
  ],
  exports: [RecordsService],
  controllers: [RecordsController],
  providers: [RecordsService],
})
export class RecordsModule {}
