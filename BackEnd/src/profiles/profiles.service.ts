import { BadRequestException, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { ProfileModel } from './entities/profiles.entity';
import { InjectRepository } from '@nestjs/typeorm';

@Injectable()
export class ProfilesService {
    constructor(
        @InjectRepository(ProfileModel)
        private readonly profilesRepository : Repository<ProfileModel>
    ){}

    async findByPublicId(publicId: string) {
        const profile = await this.profilesRepository.findOne({
            where: {
                publicId,
            }
        });

        return profile;
    }

    async existByNickname(nickname: string) {
        const nicknameExists = await this.profilesRepository.exist({
            where: {
                nickname,
            }
        });
        if(nicknameExists) {
            return true;
        }
        return false;
    }
}