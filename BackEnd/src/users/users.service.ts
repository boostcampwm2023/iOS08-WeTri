import { Injectable } from '@nestjs/common';
import { UserModel } from './entities/users.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { SignupDto } from 'src/auth/dto/signup.dto';

@Injectable()
export class UsersService {
    constructor(
        @InjectRepository(UserModel)
        private readonly usersRepository: Repository<UserModel>
    ){}

    async createUser(singupInfo: SignupDto) {
        const profile = {
            nickname: singupInfo.nickname,
            gender: singupInfo.gender,
            birthdate: singupInfo.birthdate,
        }
        const userObj = this.usersRepository.create({
            userId: singupInfo.userId,
            provider: singupInfo.provider,
            profile
        })
        
        const newUesr = await this.usersRepository.save(userObj);
        
        return newUesr;
    }

    async getUserByUserIdAndProvider(user: Pick<UserModel, 'userId' | 'provider'>) {
        return this.usersRepository.findOne({
            where: {
                userId: user.userId,
                provider: user.provider,
            },
        });
    }
}
