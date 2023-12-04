import { Body, Controller, Get, Param, ParseIntPipe, Post, Query, UseGuards } from '@nestjs/common';
import { PostsService } from './posts.service';
import { AccessTokenGuard } from 'src/auth/guard/bearerToken.guard';
import {
  ApiBody,
  ApiCreatedResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { CreatePostDto } from './dto/create-post.dto';
import { Profile } from 'src/profiles/entities/profiles.entity';
import { ProfileDeco } from 'src/profiles/decorator/profile.decorator';
import { PaginatePostDto } from './dto/paginate-post.dto';
import { GetPostsResponseDto } from './dto/get-posts-response.dto';
import { GetPostResponseDto } from './dto/get-post-response.dto';

@ApiTags('게시글 관련 API')
@Controller('api/v1/posts')
export class PostsController {
  constructor(private readonly postsService: PostsService) {}

  @UseGuards(AccessTokenGuard)
  @Post()
  @ApiOperation({ summary: '게시글 생성' })
  @ApiBody({ type: CreatePostDto })
  async createPost(
    @Body() body: CreatePostDto,
    @ProfileDeco() profile: Profile,
  ) {
    return await this.postsService.createPost(body, profile);
  }

  @Get()
  @ApiOperation({ summary: '게시글 가져오기' })
  @ApiCreatedResponse({ type: GetPostsResponseDto })
  async getPosts(@Query() query: PaginatePostDto) {
    return this.postsService.paginatePost(query);
  }
ç
  @Get(':id')
  @ApiOperation({summary: '특정 게시글 가져오기'})
  @ApiCreatedResponse({ type: GetPostResponseDto })
  async getPostById(@Param('id', ParseIntPipe) id: number) {
    return this.postsService.findOneById(id);
  }
}
