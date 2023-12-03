import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  UseGuards,
} from '@nestjs/common';
import { ProfilesService } from './profiles.service';
import { GetResProfileDto } from './dto/create-profile.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { ProfileDeco } from './decorator/profile.decorator';
import { Profile } from './entities/profiles.entity';
import { ApiBody, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../auth/guard/bearerToken.guard';

@ApiTags('Profiles API')
@Controller('profiles')
export class ProfilesController {
  constructor(private readonly profilesService: ProfilesService) {}

  @ApiOperation({ summary: '프로필을 조회한다.' })
  @ApiResponse({ type: GetResProfileDto })
  @UseGuards(AccessTokenGuard)
  @Get(':publicId')
  async getMyProfile(@Param('publicId') publicId: string) {
    return this.profilesService.getProfileAndPost(publicId);
  }

  @ApiOperation({ summary: '프로필을 수정한다. 닉네임 또는 사진' })
  @ApiBody({ type: UpdateProfileDto })
  @UseGuards(AccessTokenGuard)
  @Patch(':profileId')
  async updateProfile(
    @Param('profileId') profileId: string,
    @Body() updateProfileDto: UpdateProfileDto,
    @ProfileDeco() profile: Profile,
  ) {
    return this.profilesService.updateProfile(
      profileId,
      profile.publicId,
      updateProfileDto,
    );
  }

  @ApiOperation({ summary: '프로필을 삭제한다.' })
  @UseGuards(AccessTokenGuard)
  @Delete(':profileId')
  async deleteProfile(
    @Param('profileId') profileId: string,
    @ProfileDeco() profile: Profile,
  ) {
    return this.profilesService.deleteProfile(profileId, profile.publicId);
  }
}
