import { Injectable } from '@nestjs/common';
import { Admin } from './entities/admin.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { AuthService } from '../auth/auth.service';
import * as bcrypt from 'bcrypt';
import {
  IncorrectPasswordException,
  NotFoundAdminIdException,
} from './exceptions/admin.exception';

@Injectable()
export class AdminService {
  constructor(
    private readonly authService: AuthService,
    @InjectRepository(Admin)
    private readonly adminRepository: Repository<Admin>,
  ) {}

  async authenticateWithAdminIdAndPassword(
    admin: Pick<Admin, 'adminId' | 'adminPw'>,
  ) {
    const existingAdmin = await this.getAdminByAdminId(admin.adminId);

    if (!existingAdmin) {
      throw new NotFoundAdminIdException();
    }

    const checkPw = await bcrypt.compare(admin.adminPw, existingAdmin.adminPw);

    if (!checkPw) {
      throw new IncorrectPasswordException();
    }

    return this.authService.loginUser(existingAdmin.profile.publicId);
  }

  async getAdminByAdminId(adminId: string) {
    return await this.adminRepository.findOne({
      where: {
        adminId,
      },
    });
  }
}
