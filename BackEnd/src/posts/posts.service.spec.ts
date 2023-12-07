import { Test, TestingModule } from '@nestjs/testing';
import { PostsService } from './posts.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Post } from './entities/posts.entity';
import { RecordsService } from '../records/records.service';
import { CommonService } from '../common/common.service';
import { Repository } from 'typeorm';
import { Record } from '../records/entities/records.entity';
import { Profile } from '../profiles/entities/profiles.entity';
import {
  ExistPostException,
  NotFoundPostException,
} from './exceptions/posts.exception';
import {
  post,
  postInfo,
  posts,
  profile,
  query,
  updatePostInfo,
  updateResult,
  updatedPost,
} from './mocks/mocks';

describe('postsService', () => {
  let service: PostsService;
  let repository: Repository<Post>;
  let recordsService: RecordsService;
  let commonService: CommonService;

  const mockQueryBuilder = {
    getOne: jest.fn(),
  } as any;

  beforeEach(async () => {
    const mockRepository = () => ({
      findOneBy: jest.fn(),
      save: jest.fn(),
      update: jest.fn(),
      softDelete: jest.fn(),
    });

    const mockRecordsService = () => ({
      findById: jest.fn(),
      updateIsPostedTrue: jest.fn(),
    });

    const mockCommonService = () => ({
      paginate: jest.fn(),
      makeQueryBuilder: jest.fn(),
    });

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PostsService,
        {
          provide: getRepositoryToken(Post),
          useValue: mockRepository(),
        },
        {
          provide: RecordsService,
          useValue: mockRecordsService(),
        },
        {
          provide: CommonService,
          useValue: mockCommonService(),
        },
      ],
    }).compile();
    service = module.get<PostsService>(PostsService);
    repository = module.get<Repository<Post>>(getRepositoryToken(Post));
    recordsService = module.get<RecordsService>(RecordsService);
    commonService = module.get<CommonService>(CommonService);
  });

  describe('createPost', () => {
    it('이미 record의 post가 존재한다면 throw new ExistPostException 발생', async () => {
      const record = { isPosted: true } as Record;
      jest.spyOn(recordsService, 'findById').mockResolvedValue(record);
      await expect(
        service.createPost(postInfo, profile as Profile),
      ).rejects.toThrow(ExistPostException);
    });

    it('record의 post가 존재하지 않는다면 post 생성', async () => {
      jest
        .spyOn(recordsService, 'findById')
        .mockResolvedValue({ isPosted: false } as Record);
      jest.spyOn(repository, 'save').mockResolvedValue({ id: 5 } as Post);
      jest.spyOn(service, 'findOneById').mockResolvedValue(post);

      const result = await service.createPost(postInfo, profile);
      expect(result).toEqual(post);
    });
  });

  describe('findOneById', () => {
    it('post가 존재하지 않는다면 NotFoundPostException 발생', async () => {
      jest
        .spyOn(commonService, 'makeQueryBuilder')
        .mockImplementation(() => mockQueryBuilder);
      jest.spyOn(mockQueryBuilder, 'getOne').mockResolvedValue(null);
      await expect(service.findOneById(5)).rejects.toThrow(
        NotFoundPostException,
      );
    });

    it('post가 존재한다면 post를 반환', async () => {
      jest
        .spyOn(commonService, 'makeQueryBuilder')
        .mockImplementation(() => mockQueryBuilder);
      jest.spyOn(mockQueryBuilder, 'getOne').mockResolvedValue(post);

      const result = await service.findOneById(post.id);
      expect(result).toEqual(post);
    });
  });

  describe('paginatePosts', () => {
    it('posts 반환', async () => {
      jest.spyOn(commonService, 'paginate').mockResolvedValue(posts);

      const result = await service.paginatePosts(query);
      expect(result).toEqual(posts);
    });
  });

  describe('paginateUserPosts', () => {
    it('user의 posts 반환', async () => {
      jest.spyOn(commonService, 'paginate').mockResolvedValue(posts);

      const result = await service.paginateUserPosts(profile.publicId, query);
      expect(result).toEqual(posts);
    });
  });

  describe('updatePost', () => {
    it('update된 post 반환', async () => {
      jest.spyOn(service, 'findOneById').mockResolvedValue(post);
      jest.spyOn(repository, 'update').mockResolvedValue(updateResult);
      jest.spyOn(service, 'findOneById').mockResolvedValue(updatedPost);

      const result = await service.updatePost(updatedPost.id, updatePostInfo);
      expect(result).toEqual(updatedPost);
    });
  });
});
