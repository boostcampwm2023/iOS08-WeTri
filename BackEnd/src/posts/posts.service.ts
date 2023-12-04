import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Post } from './entities/posts.entity';
import { Repository } from 'typeorm';
import { CreatePostDto } from './dto/create-post.dto';
import { RecordsService } from 'src/records/records.service';
import { Profile } from 'src/profiles/entities/profiles.entity';
import { ExistPostException } from './exceptions/posts.exception';
import { PaginatePostDto } from './dto/paginate-post.dto';
import { CommonService } from 'src/common/common.service';

@Injectable()
export class PostsService {
    constructor(
        @InjectRepository(Post)
        private readonly postsRepository: Repository<Post>,
        private readonly recordService: RecordsService,
        private readonly commonService: CommonService,
    ){}

    async createPost(postInfo: CreatePostDto, profile: Profile) {
        const record = await this.recordService.findById(postInfo.recordId);
        if(record.isPosted) {
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

    async paginatePost(query: PaginatePostDto) {
        return await this.commonService.paginate<Post>(query, this.postsRepository);
    }
}
