import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserModel } from './entities/users.entity';

@Module({
  imports: [TypeOrmModule.forFeature([UserModel])],
  exports: [UsersService], //exports 해야 다른 모듈에서 사용 가능
  controllers: [UsersController],
  providers: [UsersService],
})
export class UsersModule {}
