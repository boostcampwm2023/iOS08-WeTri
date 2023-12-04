import { Controller, Delete, Get, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from 'src/auth/guard/bearerToken.guard';
import { ProfileDeco } from 'src/profiles/decorator/profile.decorator';
import { Profile } from 'src/profiles/entities/profiles.entity';
import { SuccessResDto } from 'src/common/dto/SuccessRes.dto';

@ApiTags('유저 API')
@Controller('api/v1/users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '유저를 삭제함 권한 필요' })
  @ApiResponse({ type: SuccessResDto })
  @Delete('me')
  async deleteUser(@ProfileDeco() profile: Profile) {
    await this.usersService.deleteUser(profile.user, profile.publicId);
  }
}
