import { Controller, Get } from '@nestjs/common';
import { WorkoutsService } from './workouts.service';
import {ApiOperation, ApiTags} from "@nestjs/swagger";

@ApiTags('운동 종류 API')
@Controller('workouts')
export class WorkoutsController {
  constructor(private readonly workoutsService: WorkoutsService) {}
  @Get()
  @ApiOperation({summary: '모든 운동 종류 조회'})
  findAll() {
    return this.workoutsService.findAll();
  }
}
