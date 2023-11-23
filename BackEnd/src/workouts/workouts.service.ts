import { Injectable } from '@nestjs/common';

@Injectable()
export class WorkoutsService {
  findAll() {
    return `This action returns all workouts`;
  }
}
