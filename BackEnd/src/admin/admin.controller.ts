import { Body, Controller, Post } from '@nestjs/common';
import { AdminService } from './admin.service';
import { LoginDto } from './dto/login.dto';
import { ApiBody, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { SignupResDto } from 'src/auth/dto/auth-response.dto';

@ApiTags('Admin')
@Controller('api/v1/admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @ApiOperation({ summary: 'Admin 로그인' })
  @ApiBody({ description: 'ID && PW', type: LoginDto })
  @ApiResponse({
    status: 200,
    description: '로그인 성공',
    type: SignupResDto
  })
  @Post('login')
  login(
    @Body() body: LoginDto
  ) {
    return this.adminService.authenticateWithAdminIdAndPassword(body);
  }
}
