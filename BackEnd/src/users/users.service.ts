import { Injectable } from '@nestjs/common';
import { UserModel } from './entities/users.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';

@Injectable()
export class UsersService {
    constructor(
        @InjectRepository(UserModel)
        private readonly usersRepository: Repository<UserModel>
    ){}

    async getUserByUserIdAndProvider(user: Pick<UserModel, 'userId' | 'provider'>) {
        return this.usersRepository.findOne({
            where: {
                userId: user.userId,
                provider: user.provider,
            },
        });
    }
}
