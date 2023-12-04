import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Workout } from './entities/workout.entity';
import { NotFoundWorkoutException } from './exceptions/workouts.exception';

@Injectable()
export class WorkoutsService {
  constructor(
    @InjectRepository(Workout)
    private readonly workoutModelRepository: Repository<Workout>,
  ) {}
  findAllWorkouts(): Promise<Workout[]> {
    return this.workoutModelRepository.find();
  }

  async findByIdWorkout(id: number): Promise<Workout> {
    const workout = await this.workoutModelRepository.findOne({
      where: {
        id,
      }
    });
    if(!workout) {
      throw new NotFoundWorkoutException();
    }
    return workout;
  }
}
