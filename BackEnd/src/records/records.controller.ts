import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { RecordsService } from './records.service';
import { CreateExerciseLogDto } from './dto/create-exerciseLog.dto';
import { AccessTokenGuard } from 'src/auth/guard/bearerToken.guard';
import { ProfileDeco } from 'src/profiles/decorator/profile.decorator';
import { Profile } from 'src/profiles/entities/profiles.entity';
import {
  ApiBody,
  ApiCreatedResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import {
  CreateRecordResDto,
  GetRecordResDto,
  GetUsersRecordsResDto,
} from './dto/record-response.dto';

@ApiTags('사용자 기록 API')
@Controller('api/v1/records')
export class RecordsController {
  constructor(private readonly recordsService: RecordsService) {}
  @Post()
  @ApiOperation({ summary: '운동 기록 생성' })
  @ApiBody({ type: CreateExerciseLogDto })
  @ApiCreatedResponse({ type: CreateRecordResDto })
  @UseGuards(AccessTokenGuard)
  async createWorkOutLog(
    @ProfileDeco() profile: Profile,
    @Body() body: CreateExerciseLogDto,
  ) {
    const workoutLog = await this.recordsService.createWorkOutLog(
      body,
      profile,
    );
    return { recordId: workoutLog.id };
  }

  @Get('me')
  @ApiOperation({ summary: '내 모든 운동 기록 조회' })
  @ApiCreatedResponse({ type: GetUsersRecordsResDto })
  @UseGuards(AccessTokenGuard)
  async getUserRecords(@ProfileDeco() profile: Profile) {
    return this.recordsService.findByProfileId(profile.id);
  }

  @Get(':recordId')
  @ApiOperation({ summary: '하나의 기록 조회' })
  @ApiCreatedResponse({ type: GetRecordResDto })
  async getRecord(@Param('recordId') recordId: number) {
    return this.recordsService.findById(recordId);
  }
}
