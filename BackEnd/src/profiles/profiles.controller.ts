import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ProfilesService } from './profiles.service';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { ProfileDeco } from './decorator/profile.decorator';
import { Profile } from './entities/profiles.entity';
import {
  ApiBody,
  ApiCreatedResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { AccessTokenGuard } from '../auth/guard/bearerToken.guard';
import { GetProfileResponseDto } from './dto/get-profile-response.dto';
import { PaginateProfilePostDto } from './dto/paginate-profile-post.dto';
import { GetProfilePostsResponseDto } from './dto/get-profile-posts-response.dto';
import { GetNicknameAvailAbailityDto } from './dto/get-nickname-availability.dto';

@ApiTags('Profiles API')
@Controller('api/v1/profiles')
export class ProfilesController {
  constructor(private readonly profilesService: ProfilesService) {}

  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '프로필을 조회한다.' })
  @ApiCreatedResponse({ type: GetProfileResponseDto })
  @Get('me')
  async getMyProfile(@ProfileDeco() profile: Profile) {
    return this.profilesService.getProfile(profile.publicId);
  }

  @ApiOperation({ summary: '특정 유저의 프로필을 조회한다.' })
  @ApiCreatedResponse({ type: GetProfileResponseDto })
  @Get('public-id/:publicId')
  getProfile(@Param('publicId') publicId: string) {
    return this.profilesService.getProfile(publicId);
  }

  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '프로필을 수정한다. 닉네임 또는 사진' })
  @ApiBody({ type: UpdateProfileDto })
  @ApiCreatedResponse({ type: GetProfileResponseDto })
  @Patch('me')
  async updateProfile(
    @Body() updateProfileDto: UpdateProfileDto,
    @ProfileDeco() profile: Profile,
  ) {
    return this.profilesService.updateProfile(
      profile.publicId,
      updateProfileDto,
    );
  }

  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '내 프로필 Post를 조회한다.' })
  @ApiCreatedResponse({ type: GetProfilePostsResponseDto })
  @Get('me/posts')
  getMyProfilePosts(
    @ProfileDeco() profile: Profile,
    @Query() query: PaginateProfilePostDto,
  ) {
    return this.profilesService.getProfilePosts(profile.publicId, query);
  }

  @ApiOperation({ summary: '특정 유저의 프로필 Post를 조회한다.' })
  @ApiCreatedResponse({ type: GetProfilePostsResponseDto })
  @Get('public-id/:publicId/posts')
  getProfilePosts(
    @Param('publicId') publicId: string,
    @Query() query: PaginateProfilePostDto,
  ) {
    return this.profilesService.getProfilePosts(publicId, query);
  }

  @ApiOperation({ summary: '닉네임 중복 검사한다.' })
  @Post('nickname-availability')
  getNicknameAvailability(@Body() body: GetNicknameAvailAbailityDto) {
    this.profilesService.validateProfileNickname(body.nickname);
    return null;
  }
}
