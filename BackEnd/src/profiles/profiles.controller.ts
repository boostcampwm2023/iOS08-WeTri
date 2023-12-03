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
import { UpdateProfileDto } from './dto/update-profile.dto';
import { ProfileDeco } from './decorator/profile.decorator';
import { Profile } from './entities/profiles.entity';
import { ApiBody, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../auth/guard/bearerToken.guard';
import { GetProfileAndPosts, SuccessProfile } from './dto/create-profile.dto';

@ApiTags('Profiles API')
@Controller('profiles')
@UseGuards(AccessTokenGuard)
export class ProfilesController {
  constructor(private readonly profilesService: ProfilesService) {}

  @ApiOperation({ summary: '프로필을 조회한다.' })
  @ApiResponse({
    status: 200,
    description: '프로필 조회 성공',
    schema: GetProfileAndPosts(),
  })
  @Get(':publicId')
  async getMyProfile(@Param('publicId') publicId: string) {
    return this.profilesService.getProfileAndPost(publicId);
  }

  @ApiOperation({ summary: '프로필을 수정한다. 닉네임 또는 사진' })
  @ApiBody({ type: UpdateProfileDto })
  @ApiResponse({
    status: 200,
    description: '프로필 수정 성공',
    schema: SuccessProfile(),
  })
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
  @ApiResponse({
    status: 200,
    description: '프로필 삭제 성공',
    schema: SuccessProfile(),
  })
  @Delete(':profileId')
  async deleteProfile(
    @Param('profileId') profileId: string,
    @ProfileDeco() profile: Profile,
  ) {
    return this.profilesService.deleteProfile(profileId, profile.publicId);
  }
}
