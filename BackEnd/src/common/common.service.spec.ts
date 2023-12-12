import { Test, TestingModule } from '@nestjs/testing';
import { CommonService } from './common.service';
import { QueryFailedError, Repository } from 'typeorm';
import { posts } from '../posts/mocks/mocks';
import { Post } from '../posts/entities/posts.entity';
import {
  mockGetCreateUpdateQueryOptions,
  mockItems,
  mockPaginationDto,
} from './mocks/mocks';
import { InternalServerErrorException } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';

describe('commonService', () => {
  let service: CommonService;
  let postsRepository: Repository<Post>;
  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CommonService,
        {
          provide: getRepositoryToken(Post),
          useValue: {
            createQueryBuilder: jest.fn(),
          },
        },
      ],
    }).compile();
    service = module.get<CommonService>(CommonService);
    postsRepository = module.get<Repository<Post>>(getRepositoryToken(Post));
  });

  describe('paginate', () => {
    const mockQueryBuilder = {
      getMany: jest.fn(),
    } as any;
    it('QueryBuilder가 잘못 설정되어 있다면 InternalServerErrorException 에러', async () => {
      jest.spyOn(service, 'makeQueryBuilder').mockReturnValue(mockQueryBuilder);
      jest
        .spyOn(mockQueryBuilder, 'getMany')
        .mockRejectedValue(
          new QueryFailedError('SELECT *', [], 'Error message'),
        );
      await expect(
        service.paginate(
          mockPaginationDto,
          postsRepository,
          mockGetCreateUpdateQueryOptions,
        ),
      ).rejects.toThrow(InternalServerErrorException);
    });

    it('게시글 요청하면 paginate 함수를 실행해서 요청한 게시글들, metaData 반환', async () => {
      jest.spyOn(service, 'makeQueryBuilder').mockReturnValue(mockQueryBuilder);
      jest.spyOn(mockQueryBuilder, 'getMany').mockResolvedValue(mockItems);
      const result = await service.paginate(
        mockPaginationDto,
        postsRepository,
        mockGetCreateUpdateQueryOptions,
      );
      expect(result).toEqual(posts);
    });
  });
});
