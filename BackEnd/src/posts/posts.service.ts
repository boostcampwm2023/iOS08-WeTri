import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Post } from './entities/posts.entity';
import { FindManyOptions, Repository } from 'typeorm';
import { CreatePostDto } from './dto/create-post.dto';
import { RecordsService } from 'src/records/records.service';
import { Profile } from 'src/profiles/entities/profiles.entity';
import { ExistPostException, NotFoundPostException } from './exceptions/posts.exception';
import { PaginatePostDto } from './dto/paginate-post.dto';
import { CommonService } from 'src/common/common.service';
import { UpdatePostDto } from './dto/update-post.dto';

@Injectable()
export class PostsService {
  constructor(
    @InjectRepository(Post)
    private readonly postsRepository: Repository<Post>,
    private readonly recordService: RecordsService,
    private readonly commonService: CommonService,
  ) { }

  async createPost(postInfo: CreatePostDto, profile: Profile) {
    const record = await this.recordService.findById(postInfo.recordId);
    if (record.isPosted) {
      throw new ExistPostException();
    }
    this.recordService.updateIsPostedTrue(record);
    return await this.postsRepository.save({
      publicId: profile.publicId,
      content: postInfo.content,
      postUrl: postInfo.postUrl,
      record,
      profile,
    });
  }

  async paginatePosts(query: PaginatePostDto) {
    return await this.commonService.paginate<Post>(query, this.postsRepository);
  }

  async findOneById(id: number) {
    const post = await this.postsRepository.findOneBy({ id });
    if (!post) {
      throw new NotFoundPostException();
    }
    return post;
  }

  async paginateUserPosts(publicId: string, query: PaginatePostDto) {
    const findManyOptions: FindManyOptions<Post> = {};
    findManyOptions.where = { publicId }
    return await this.commonService.paginate<Post>(query, this.postsRepository, findManyOptions);
  }

  async updatePost(id: number, updatePostInfo: UpdatePostDto) {
    await this.findOneById(id);
    await this.postsRepository.update(id, updatePostInfo);
    return await this.postsRepository.findOneBy({ id });
  }

  async deletePost(id: number) {
    await this.findOneById(id);
    await this.postsRepository.softDelete(id);
  }
}
