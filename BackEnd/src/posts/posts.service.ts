import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Post } from './entities/posts.entity';
import { Repository } from 'typeorm';
import { CreatePostDto } from './dto/create-post.dto';
import { RecordsService } from '../records/records.service';
import { Profile } from '../profiles/entities/profiles.entity';
import {
  ExistPostException,
  NotFoundPostException,
} from './exceptions/posts.exception';
import { PaginatePostDto } from './dto/paginate-post.dto';
import { CommonService } from '../common/common.service';
import { UpdatePostDto } from './dto/update-post.dto';
import { getCreateUpdateQueryOptions } from './queryOptions/get-create-update.queryOptions';

@Injectable()
export class PostsService {
  constructor(
    @InjectRepository(Post)
    private readonly postsRepository: Repository<Post>,
    private readonly recordService: RecordsService,
    private readonly commonService: CommonService,
  ) {}

  async createPost(postInfo: CreatePostDto, profile: Profile) {
    const record = await this.recordService.findById(postInfo.recordId);
    if (record.isPosted) {
      throw new ExistPostException();
    }
    this.recordService.updateIsPostedTrue(record);
    const post = await this.postsRepository.save({
      publicId: profile.publicId,
      content: postInfo.content,
      postUrl: postInfo.postUrl,
      record,
      profile,
    }); 
    return await this.findOneById(post.id);
  }

  async paginatePosts(query: PaginatePostDto) {
    return await this.commonService.paginate<Post>(query, this.postsRepository, getCreateUpdateQueryOptions);
  }

  async findOneById(id: number) {
    const queryBuilder = this.commonService.makeQueryBuilder(this.postsRepository, getCreateUpdateQueryOptions, {where: {id}});
    const post = await queryBuilder.getOne();
    if (!post) {
      throw new NotFoundPostException();
    }
    return post;
  }

  async paginateUserPosts(publicId: string, query: PaginatePostDto) {
    return await this.commonService.paginate<Post>(
      query,
      this.postsRepository,
      getCreateUpdateQueryOptions,
      {where: {publicId}},
    );
  }

  async updatePost(id: number, updatePostInfo: UpdatePostDto) {
    await this.findOneById(id);
    await this.postsRepository.update(id, updatePostInfo);
    return await this.findOneById(id);
  }

  async deletePost(id: number) {
    await this.findOneById(id);
    await this.postsRepository.softDelete(id);
  }
}
