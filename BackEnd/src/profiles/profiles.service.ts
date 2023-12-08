import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Profile } from './entities/profiles.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { Post } from '../posts/entities/posts.entity';
import { PaginateProfilePostDto } from './dto/paginate-profile-post.dto';
import { CommonService } from '../common/common.service';
import { NicknameDuplicateException } from '../auth/exceptions/auth.exception';
import { getProfilePostsQueryOptions } from './queryOptions/get-profilePosts-queryOptions';

@Injectable()
export class ProfilesService {
  constructor(
    @InjectRepository(Post)
    private readonly postsRepository: Repository<Post>,
    @InjectRepository(Profile)
    private readonly profilesRepository: Repository<Profile>,
    private readonly commonService: CommonService,
  ) {}

  async updateProfile(publicId: string, updateProfileDto: UpdateProfileDto) {
    if (await this.validateProfileNickname(updateProfileDto.nickname)) {
      throw new NicknameDuplicateException();
    }
    await this.profilesRepository.update({ publicId }, updateProfileDto);
    return this.getProfile(publicId);
  }

  async deleteProfile(publicId: string) {
    return this.profilesRepository.delete({ publicId });
  }

  async validateProfileNickname(nickname: string) {
    return await this.profilesRepository.exist({
      where: {
        nickname,
      },
    });
  }

  async getProfile(publicId: string) {
    return await this.profilesRepository.findOne({
      where: {
        publicId,
      },
    });
  }

  async getProfilePosts(publicId: string, query: PaginateProfilePostDto) {
    return await this.commonService.paginate<Post>(
      query,
      this.postsRepository,
      getProfilePostsQueryOptions,
      {
        where: { publicId },
        select: ['id', 'imagesUrl'],
      },
    );
  }
}
