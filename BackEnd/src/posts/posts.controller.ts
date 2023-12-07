import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
  Query,
  UseGuards,
} from '@nestjs/common';
import { PostsService } from './posts.service';
import { AccessTokenGuard } from '../auth/guard/bearerToken.guard';
import {
  ApiBody,
  ApiCreatedResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { CreatePostDto } from './dto/create-post.dto';
import { Profile } from '../profiles/entities/profiles.entity';
import { ProfileDeco } from '../profiles/decorator/profile.decorator';
import { PaginatePostDto } from './dto/paginate-post.dto';
import {
  GetPostsResponseDto,
  PostDto,
  PostsPaginateResDto,
} from './dto/get-posts-response.dto';
import { GetPostResponseDto } from './dto/get-create-update-post-response.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { DeletePostResponseDto } from './dto/delete-post-response.dto';

@ApiTags('게시글 관련 API')
@Controller('api/v1/posts')
export class PostsController {
  constructor(private readonly postsService: PostsService) {}

  @UseGuards(AccessTokenGuard)
  @Post()
  @ApiOperation({ summary: '게시글 생성' })
  @ApiCreatedResponse({ type: GetPostResponseDto })
  @ApiBody({ type: CreatePostDto })
  async createPost(
    @Body() body: CreatePostDto,
    @ProfileDeco() profile: Profile,
  ): Promise<PostDto> {
    return this.postsService.createPost(body, profile);
  }

  @Get()
  @ApiOperation({ summary: '게시글 가져오기' })
  @ApiCreatedResponse({ type: GetPostsResponseDto })
  async getPosts(
    @Query() query: PaginatePostDto,
  ): Promise<PostsPaginateResDto> {
    return this.postsService.paginatePosts(query);
  }

  @Get(':id')
  @ApiOperation({ summary: '특정 게시글 가져오기' })
  @ApiCreatedResponse({ type: GetPostResponseDto })
  async getPostById(@Param('id', ParseIntPipe) id: number): Promise<PostDto> {
    return this.postsService.findOneById(id);
  }

  @Get('public-id/:publicId')
  @ApiOperation({ summary: '유저의 게시글 가져오기' })
  @ApiCreatedResponse({ type: GetPostsResponseDto })
  async getUserPosts(
    @Param('publicId') publicId: string,
    @Query() query: PaginatePostDto,
  ): Promise<PostsPaginateResDto> {
    return this.postsService.paginateUserPosts(publicId, query);
  }

  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '나의 게시글 가져오기' })
  @ApiCreatedResponse({ type: GetPostsResponseDto })
  @Get('user/me')
  async getMyPosts(
    @ProfileDeco() profile: Profile,
    @Query() query: PaginatePostDto,
  ): Promise<PostsPaginateResDto> {
    return this.postsService.paginateUserPosts(profile.publicId, query);
  }

  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '내 게시글 수정하기' })
  @ApiCreatedResponse({ type: GetPostResponseDto })
  @Put(':id')
  async updateMyPost(
    @Param('id', ParseIntPipe) id: number,
    @Body() body: UpdatePostDto,
  ): Promise<PostDto> {
    return this.postsService.updatePost(id, body);
  }

  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '내 게시글 삭제하기' })
  @ApiCreatedResponse({ type: DeletePostResponseDto })
  @Delete(':id')
  async deleteMypost(@Param('id', ParseIntPipe) id: number) {
    await this.postsService.deletePost(id);
  }
}
