import { Redis } from 'ioredis';
import { GetuserByUserIdAndProViderDto } from './../auth/dto/getUserByUserIdAndProvider.dto';
import { Inject, Injectable } from '@nestjs/common';
import { User } from './entities/users.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { SignupDto } from '../auth/dto/signup.dto';
import { ProfilesService } from 'src/profiles/profiles.service';
import { Profile } from 'src/profiles/entities/profiles.entity';
import { NotFoundUserException } from './exceptions/users.exception';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
    @Inject('DATA_REDIS')
    private readonly redisData: Redis,
    private readonly profilesService: ProfilesService,
  ) {}

  async createUser(signupInfo: SignupDto) {
    const userId = await this.redisData.get(signupInfo.mappedUserID);
    const profile = {
      nickname: signupInfo.nickname,
      gender: signupInfo.gender,
      birthdate: signupInfo.birthdate,
      profileImage: signupInfo.profileImage,
    };
    const userObj = this.usersRepository.create({
      userId,
      provider: signupInfo.provider,
      profile,
    });
    const newUser = await this.usersRepository.save(userObj);
    await this.redisData.del(signupInfo.mappedUserID);
    return newUser;
  }

  async getUserByUserIdAndProvider(userInfo: GetuserByUserIdAndProViderDto) {
    return await this.usersRepository.findOne({
      where: {
        userId: userInfo.userId,
        provider: userInfo.provider,
      },
    });
  }

  async deleteUser(user: User, publicId: string) {
    await this.profilesService.deleteProfile(publicId);
    await this.usersRepository.delete(user);
  }
}
