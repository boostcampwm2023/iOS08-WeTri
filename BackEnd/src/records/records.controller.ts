import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { RecordsService } from './records.service';
import { CreateExerciseLogDto } from './dto/create-exerciseLog.dto';
import { AccessTokenGuard } from 'src/auth/guard/bearerToken.guard';

@Controller('api/v1/records')
export class RecordsController {
  constructor(private readonly recordsService: RecordsService) {}

  @Post()
  @UseGuards(AccessTokenGuard)
  async createExerciseLog(@Body() body: CreateExerciseLogDto) {
    
  }
}
