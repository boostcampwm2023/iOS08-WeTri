import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { RecordModel } from './entities/records.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { CreateExerciseLogDto } from './dto/create-exerciseLog.dto';
import { ProfileModel } from 'src/profiles/entities/profiles.entity';

@Injectable()
export class RecordsService {
  constructor(
    @InjectRepository(RecordModel)
    private readonly recordsRepository: Repository<RecordModel>,
  ) {}

  async createExerciseLog(
    exerciseLog: CreateExerciseLogDto,
    profile: ProfileModel,
  ) {
    return await this.recordsRepository.save({
      ...exerciseLog,
      checker: false,
      profile,
    });
  }
}
