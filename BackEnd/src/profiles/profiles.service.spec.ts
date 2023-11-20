import { Test, TestingModule } from '@nestjs/testing';
import { ProfilesService } from './profiles.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ProfileModel } from './entities/profiles.entity';

describe('ProfilesService', () => {
  let service: ProfilesService;
  let mockRepository;

  beforeEach(async () => {
    // Repository 메소드 모의 구현
    mockRepository = {
      findOne: jest.fn(),
    };

    // 모듈 설정
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProfilesService,
        {
          provide: getRepositoryToken(ProfileModel),
          useValue: mockRepository,
        },
      ],
    }).compile();

    service = module.get<ProfilesService>(ProfilesService);
  });

  it('should be defined', () => {
    //서비스가 정의되어 있는지 확인한다.
    expect(service).toBeDefined();
  });

  // findByPublicId 함수 테스트
  // describe('findByPublicId', () => {
  //   it('should return a profile for a given publicId', async () => {
  //     const testPublicId = 'some-public-id';
  //     const expectedProfile = { id: 1, publicId: testPublicId, nickname: 'testNickname' };

  //     mockRepository.findOne.mockResolvedValue(expectedProfile);

  //     const result = await service.findByPublicId(testPublicId);
  //     expect(result).toEqual(expectedProfile);
  //     expect(mockRepository.findOne).toHaveBeenCalledWith({
  //       where: { publicId: testPublicId },
  //     });
  //   });
  // });
});