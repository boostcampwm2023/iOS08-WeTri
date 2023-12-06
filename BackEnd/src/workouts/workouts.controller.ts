import { Controller, Get, UseGuards } from '@nestjs/common';
import { WorkoutsService } from './workouts.service';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import {WorkoutResDto} from './dto/workout-response.dto';
import { AccessTokenGuard } from '../auth/guard/bearerToken.guard';
import { Workout } from './entities/workout.entity';

@ApiTags('운동 종류 API')
@Controller('api/v1/workouts')
@UseGuards(AccessTokenGuard)
export class WorkoutsController {
  constructor(private readonly workoutsService: WorkoutsService) {}
  @Get()
  @ApiOperation({ summary: '모든 운동 종류 조회' })
  @ApiResponse({ type: WorkoutResDto })
  getAllWorkout(): Promise<Workout[]> {
    return this.workoutsService.findAllWorkouts();
  }
}
