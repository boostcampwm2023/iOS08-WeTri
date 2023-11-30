import { Redis } from 'ioredis';
import { GetuserByUserIdAndProViderDto } from './../auth/dto/getUserByUserIdAndProvider.dto';
import { Inject, Injectable } from '@nestjs/common';
import { User } from './entities/users.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { SignupDto } from '../auth/dto/signup.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
    @Inject('DATA_REDIS')
    private readonly redisData: Redis,
  ) {}

  async createUser(singupInfo: SignupDto) {
    const userId = await this.redisData.get(singupInfo.mappedUserID);
    const profile = {
      nickname: singupInfo.nickname,
      gender: singupInfo.gender,
      birthdate: singupInfo.birthdate,
    };
    const userObj = this.usersRepository.create({
      userId,
      provider: singupInfo.provider,
      profile,
    });
    const newUesr = await this.usersRepository.save(userObj);
    await this.redisData.del(singupInfo.mappedUserID);
    return newUesr;
  }

  async getUserByUserIdAndProvider(userInfo: GetuserByUserIdAndProViderDto) {
    return await this.usersRepository.findOne({
      where: {
        userId: userInfo.userId,
        provider: userInfo.provider,
      },
    });
  }
}
