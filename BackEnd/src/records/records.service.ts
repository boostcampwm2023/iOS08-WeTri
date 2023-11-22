import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { RecordModel } from './entities/records.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { CreateExerciseLogDto } from './dto/create-exerciseLog.dto';
import { ProfileModel } from 'src/profiles/entities/profiles.entity';
import { NotFoundRecordException } from './exceptions/records.exception';

@Injectable()
export class RecordsService {
  constructor(
    @InjectRepository(RecordModel)
    private readonly recordsRepository: Repository<RecordModel>,
  ) {}

  async createWorkOutLog(
    exerciseLog: CreateExerciseLogDto,
    profile: ProfileModel,
  ) {
    return await this.recordsRepository.save({
      ...exerciseLog,
      profile,
    });
  }

  async findByProfileId(profileId: number) {
    return await this.recordsRepository.find({
      where: {
        profile: {id: profileId},
      }
    });
  }

  async findById(recordId: number) {
    const result = await this.recordsRepository.findOne({
      where: {
        id: recordId,
      }
    });
    if(!result) {
      throw new NotFoundRecordException();
    }

    return result;
  }
}
