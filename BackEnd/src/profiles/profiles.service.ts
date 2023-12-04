import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Profile } from './entities/profiles.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { PublicIdMismatchException } from './exception/profile.exception';
import { Post } from '../posts/entities/posts.entity';

@Injectable()
export class ProfilesService {
  constructor(
    @InjectRepository(Post)
    private readonly postsRepository: Repository<Post>,
    @InjectRepository(Profile)
    private readonly profilesRepository: Repository<Profile>,
  ) {}

  async getProfileAndPost(publicId: string) {
    const posts = await this.postsRepository.find({
      where: {
        publicId: publicId,
      },
      order: {
        createdAt: 'DESC',
      },
      take: 9,
      select: ['id', 'postUrl'],
    });
    const profile = await this.profilesRepository.findOne({
      where: {
        publicId,
      },
      select: ['nickname', 'gender', 'birthdate', 'publicId', 'profileImage'],
    });
    return {
      profile,
      posts,
    };
  }

  async updateProfile(
    profileId: string,
    publicId: string,
    updateProfileDto: UpdateProfileDto,
  ) {
    if (!this.validateProfileId(profileId, publicId)) {
      throw new PublicIdMismatchException();
    }
    return this.profilesRepository.update({ publicId }, updateProfileDto);
  }

  async deleteProfile(profileId: string, publicId: string) {
    if (!this.validateProfileId(profileId, publicId)) {
      throw new PublicIdMismatchException();
    }
    return this.profilesRepository.delete({ publicId });
  }

  private validateProfileId(profileId: string, publicId: string) {
    return profileId === publicId;
  }
  async validateProfileNickname(nickname: string) {
    return this.profilesRepository.exist({
      where: {
        nickname,
      },
    });
  }

  async getProfile(publicId: string) {
    return this.profilesRepository.findOne({
      where: {
        publicId,
      },
    });
  }
}
