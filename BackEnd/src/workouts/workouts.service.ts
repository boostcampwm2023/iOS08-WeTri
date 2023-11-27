import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Workout } from './entities/workout.entity';

@Injectable()
export class WorkoutsService {
  constructor(
    @InjectRepository(Workout)
    private readonly workoutModelRepository: Repository<Workout>,
  ) {}
  findAllWorkouts(): Promise<Workout[]> {
    return this.workoutModelRepository.find();
  }
}
