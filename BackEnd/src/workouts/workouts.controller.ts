import { Controller, Get } from '@nestjs/common';
import { WorkoutsService } from './workouts.service';
import {ApiOperation, ApiResponse, ApiTags} from "@nestjs/swagger";
import {WorkoutResDto} from "./dto/workout-response.dto";

@ApiTags('운동 종류 API')
@Controller('workouts')
export class WorkoutsController {
  constructor(private readonly workoutsService: WorkoutsService) {}
  @Get()
  @ApiOperation({summary: '모든 운동 종류 조회'})
  @ApiResponse({
    status: 200,
    description: '성공',
    type: WorkoutResDto,
  })
  getAllWorkout() {
    return this.workoutsService.findAll();
  }
}
