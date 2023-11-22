import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
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
  async createWorkOutLog(
    @Profile() profile: ProfileModel,
    @Body() body: CreateExerciseLogDto,
  ) {
    const workoutLog = await this.recordsService.createWorkOutLog(
      body,
      profile,
    );
    return { recordId: workoutLog.id };
  }

  @Get('me')
  @UseGuards(AccessTokenGuard)
  async getUserRecords(@Profile() profile: ProfileModel) {
    return this.recordsService.findByProfileId(profile.id);
  }

  @Get(':recordId')
  async getRecord(@Param('recordId') recordId: number) {
    return this.recordsService.findById(recordId);
  }
}
