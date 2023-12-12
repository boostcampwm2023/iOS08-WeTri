import { Controller, Get, Post, Body, Delete, UseGuards } from '@nestjs/common';
import { MatchesService } from './matches.service';
import { CreateMatchDto } from './dto/create-match.dto';
import { AccessTokenGuard } from '../../auth/guard/bearerToken.guard';
import { ProfileDeco } from '../../profiles/decorator/profile.decorator';
import { Profile } from '../../profiles/entities/profiles.entity';
import {
  RandomMatchDto,
  RandomMatchResDto,
  randomNoMatchingResDto,
} from './dto/random-match.dto';
import { ApiBody, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';

@ApiTags('매칭 API')
@Controller('api/v1/matches')
@UseGuards(AccessTokenGuard)
export class MatchesController {
  constructor(private readonly matchesService: MatchesService) {}

  @ApiOperation({ summary: '매칭 시작' })
  @ApiBody({ type: CreateMatchDto })
  @ApiResponse({
    status: 200,
    description: '매칭이 시작이 성공 했을 경우',
    schema: {
      example: {
        code: null,
        errorMessage: null,
        data: null,
      },
    },
  })
  @Post('start')
  startMatch(
    @ProfileDeco() profile: Profile,
    @Body() createMatchDto: CreateMatchDto,
  ) {
    return this.matchesService.startMatch(profile, createMatchDto);
  }

  @ApiOperation({ summary: '매칭이 되었니?' })
  @ApiBody({ type: RandomMatchDto })
  @ApiResponse({
    status: 200,
    description: '매칭이 되었을 경우',
    type: RandomMatchResDto,
  })
  @ApiResponse({
    status: 201,
    description: '매칭이 안되었을 경우',
    schema: randomNoMatchingResDto(),
  })
  @Post('random')
  isRandomMatched(
    @ProfileDeco() profile: Profile,
    @Body() randomMatchDto: RandomMatchDto,
  ) {
    return this.matchesService.isRandomMatched(profile, randomMatchDto);
  }

  @ApiOperation({ summary: '매칭 취소' })
  @ApiBody({ type: CreateMatchDto })
  @ApiResponse({
    status: 200,
    description: '매칭이 취소가 성공했을 경우',
    schema: {
      example: {
        code: null,
        errorMessage: null,
        data: null,
      },
    },
  })
  @Delete('cancel')
  cancelMatch(
    @ProfileDeco() profile: Profile,
    @Body() createMatchDto: CreateMatchDto,
  ) {
    return this.matchesService.cancelMatch(profile, createMatchDto);
  }
}
