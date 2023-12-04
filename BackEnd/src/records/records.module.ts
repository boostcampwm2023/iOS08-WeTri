import { Module } from '@nestjs/common';
import { RecordsService } from './records.service';
import { RecordsController } from './records.controller';
import { AuthModule } from 'src/auth/auth.module';
import { ProfilesModule } from 'src/profiles/profiles.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Record } from './entities/records.entity';
import { WorkoutsModule } from 'src/workouts/workouts.module';

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
