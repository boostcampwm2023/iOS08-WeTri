import { Test, TestingModule } from '@nestjs/testing';
import { MatchesService } from './matches.service';
import { Profile } from '../../profiles/entities/profiles.entity';
import { RandomMatchDto } from './dto/random-match.dto';
import {MATCHES_API_TIME_OUT} from "./constant/matches.constant";

describe('MatchesService', () => {
  let service: MatchesService;
  let rpush: jest.Mock;
  let lrem: jest.Mock;
  let get: jest.Mock;
  let lrange: jest.Mock;
  let set: jest.Mock;
  let expire: jest.Mock;
  let del: jest.Mock;
  let llen: jest.Mock;
  let multi: jest.Mock;

  beforeEach(async () => {
    rpush = jest.fn();
    lrem = jest.fn();
    get = jest.fn();
    lrange = jest.fn();
    set = jest.fn();
    expire = jest.fn();
    del = jest.fn();
    llen = jest.fn();
    const multiMock = {
      set: jest.fn().mockReturnThis(),
      expire: jest.fn().mockReturnThis(),
      ltrim: jest.fn().mockReturnThis(),
      exec: jest.fn().mockResolvedValue([]),
    };
    multi = jest.fn(() => multiMock);
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MatchesService,
        {
          provide: 'DATA_REDIS',
          useValue: {
            rpush,
            lrem,
            get,
            lrange,
            set,
            expire,
            del,
            llen,
            multi,
          },
        },
      ],
    }).compile();

    service = module.get<MatchesService>(MatchesService);
  });

  describe('매칭 API 메서드 테스트', () => {
    let profile: Profile;
    let createMatchDto;

    beforeEach(() => {
      profile = { publicId: 'TestUser' } as Profile;
      createMatchDto = { workoutId: 1 };
    });

    it('매칭을 시작하면 redis에는 직렬화된 profile를 matching:1 key에 value로 저장한다.', async () => {
      await service.startMatch(profile, createMatchDto);
      expect(rpush).toHaveBeenCalledWith(`matching:1`, JSON.stringify(profile));
    });

    it('매칭을 취소하면, maching:1에 있는 value는 삭제가 되어야 한다.', async () => {
      await service.cancelMatch(profile, createMatchDto);
      expect(lrem).toHaveBeenCalledWith(
        `matching:1`,
        0,
        JSON.stringify(profile),
      );
    });

    it('랜덤 매칭 2명일 때, 기다린 시간이 60초 그리고 레디스가 잘 작동하는지 테스트한다.', async () => {
      get.mockResolvedValue(null);
      llen.mockResolvedValue(2);
      lrange.mockResolvedValue([JSON.stringify(profile)]);

      const randomMatchDto: RandomMatchDto = { workoutId: 1, waitingTime: 60 };
      const result = await service.isRandomMatched(profile, randomMatchDto);

      expect(get).toHaveBeenCalledWith(`userMatch:TestUser`);
      expect(llen).toHaveBeenCalledWith(`matching:1`);
      expect(lrange).toHaveBeenCalledWith(`matching:1`, 0, 1);
      expect(result).toBeDefined();
      expect(result.matched).toBeTruthy();
    });
  });

  describe('matchingAlgorithm 메서드 검증', () => {
    it('대기 큐에 2명이 존재하고, 기다린 시간이 20초라면?', () => {
      const queueLength = 2;
      const waitingTime = 20;

      const result = service['matchingAlgorithm'](queueLength, waitingTime);

      expect(result).toEqual(1);
    });

    it('대기 큐에 3명이 존재하고, 기다린 시간이 30초라면?', () => {
      const queueLength = 3;
      const waitingTime = 40;

      const result = service['matchingAlgorithm'](queueLength, waitingTime);

      expect(result).toEqual(3);
    });

    it('대기 큐에 4명이 존재하고, 기다린 시간이 10초라면?', () => {
      const queueLength = 4;
      const waitingTime = 10;

      const result = service['matchingAlgorithm'](queueLength, waitingTime);

      expect(result).toEqual(4);
    });
    it('대기 큐에 5명이 존재하고, 기다린 시간이 0초라면?', () => {
      const queueLength = 5;
      const waitingTime = 0;

      const result = service['matchingAlgorithm'](queueLength, waitingTime);

      expect(result).toEqual(5);
    });
  });

  describe('initMatch 메서드 검증', () => {
    it('닉네임과 운동 종류가 주어질 때, 실제로 리스트에서 제거 및 매칭에서 제거되는지 확인한다.', async () => {
      const profile = { publicId: 'TestUser' } as Profile;
      const workoutId = 1;

      await service['initMatch'](profile, workoutId);

      expect(lrem).toHaveBeenCalledWith(
        `matching:${workoutId}`,
        0,
        JSON.stringify(profile),
      );
      expect(del).toHaveBeenCalledWith(`userMatch:${profile.publicId}`);
    });
  });
});
