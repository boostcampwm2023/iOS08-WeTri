import { Injectable } from '@nestjs/common';
import { UserModel } from './entities/users.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { ProfileModel } from 'src/profiles/entities/profiles.entity';

@Injectable()
export class UsersService {
    constructor(
        @InjectRepository(UserModel)
        private readonly usersRepository: Repository<UserModel>
    ){}

    async createUser(user: Pick<UserModel, 'userId' | 'provider'>, profile: Pick<ProfileModel, 'nickname' | 'gender' | 'birthdate' | 'publicId'>) {
        const userObj = this.usersRepository.create({
            userId: user.userId,
            provider: user.provider,
            profile,
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
