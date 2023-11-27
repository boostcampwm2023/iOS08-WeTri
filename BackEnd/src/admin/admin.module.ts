import { Module } from '@nestjs/common';
import { AdminService } from './admin.service';
import { AdminController } from './admin.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Admin } from './entities/admin.entity';
import { AuthModule } from 'src/auth/auth.module';

@Module({
  imports: [TypeOrmModule.forFeature([Admin]), AuthModule],
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
