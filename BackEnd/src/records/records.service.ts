import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Record } from './entities/records.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { CreateExerciseLogDto } from './dto/create-exerciseLog.dto';
import { Profile } from 'src/profiles/entities/profiles.entity';
import { NotFoundRecordException } from './exceptions/records.exception';
import { WorkoutsService } from 'src/workouts/workouts.service';

@Injectable()
export class RecordsService {
  constructor(
    @InjectRepository(Record)
    private readonly recordsRepository: Repository<Record>,
    private readonly workoutServices: WorkoutsService,
  ) {}

  async createWorkOutLog(exerciseLog: CreateExerciseLogDto, profile: Profile) {
    const workout = await this.workoutServices.findByIdWorkout(
      exerciseLog.workoutId,
    );
    const { workoutId, ...splitedExerciseLog } = exerciseLog;
    return await this.recordsRepository.save({
      ...splitedExerciseLog,
      profile,
      workout,
    });
  }

  findByDate(profileId: number, year: number, month: number, day: number) {
    return this.recordsRepository
      .createQueryBuilder('record')
      .leftJoinAndSelect('record.workout', 'workout')
      .where('record.profileId = :profileId', { profileId })
      .andWhere(
        `YEAR(record.createdAt) = :year AND MONTH(record.createdAt) = :month AND DAY(record.createdAt) = :day`,
        { year, month, day },
      )
      .getMany();
  }

  async findById(recordId: number) {
    const result = await this.recordsRepository.findOne({
      where: {
        id: recordId,
      },
    });
    if (!result) {
      throw new NotFoundRecordException();
    }

    return result;
  }

  async updateIsPostedTrue(record: Record) {
    record.isPosted = true;
    await this.recordsRepository.save(record);
  }
}
