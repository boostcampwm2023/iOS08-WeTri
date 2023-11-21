import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { RecordsService } from './records.service';
import { CreateExerciseLogDto } from './dto/create-exerciseLog.dto';
import { AccessTokenGuard } from 'src/auth/guard/bearerToken.guard';
import { Profile } from 'src/profiles/decorator/profile.decorator';
import { ProfileModel } from 'src/profiles/entities/profiles.entity';

@Controller('api/v1/records')
export class RecordsController {
  constructor(private readonly recordsService: RecordsService) {}
  @Post()
  @UseGuards(AccessTokenGuard)
  async createExerciseLog(
    @Profile() profile: ProfileModel,
    @Body() body: CreateExerciseLogDto
    ) {
      return this.recordsService.createExerciseLog(body, profile);
  }
}
