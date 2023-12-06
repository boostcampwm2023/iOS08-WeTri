import { Test, TestingModule } from '@nestjs/testing';
import { WorkoutsService } from './workouts.service';
import { Workout } from './entities/workout.entity';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import {
  NotFoundAllWorkoutsException,
  NotFoundWorkoutException,
} from './exceptions/workouts.exception';

describe('WorkoutsService', () => {
  let service: WorkoutsService;
  let mockRepository: Partial<Repository<Workout>>;

  beforeEach(async () => {
    const mockWorkouts: Workout[] = [
      { id: 1, name: '달리기', icon: 'a' } as Workout,
      { id: 2, name: '수영', icon: 'b' } as Workout,
      { id: 3, name: '사이클', icon: 'c' } as Workout,
    ];

    mockRepository = {
      find: jest.fn().mockResolvedValue(mockWorkouts),
      findOne: jest.fn().mockResolvedValue(mockWorkouts[0]),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WorkoutsService,
        {
          provide: getRepositoryToken(Workout),
          useValue: mockRepository,
        },
      ],
    }).compile();

    service = module.get<WorkoutsService>(WorkoutsService);
  });

  describe('findAllWorkouts', () => {
    it('요청에 대해 모든 목 데이터를 동일하게 리턴해야한다.', async () => {
      expect(await service.findAllWorkouts()).toEqual([
        { id: 1, name: '달리기', icon: 'a' } as Workout,
        { id: 2, name: '수영', icon: 'b' } as Workout,
        { id: 3, name: '사이클', icon: 'c' } as Workout,
      ]);
      expect(mockRepository.find).toHaveBeenCalled();
    });

    it('요청이 왔을 때, 만약 DB에 데이터가 없다면, NotFoundAllWorkoutsException을 던져야한다.', async () => {
      mockRepository.find = jest.fn().mockResolvedValue([]);
      await expect(service.findAllWorkouts()).rejects.toThrow(
        NotFoundAllWorkoutsException,
      );
    });

    describe('findOneWorkout', () => {
      it('요청에 대해, 하나의 목 데이터를 리턴해야한다.', async () => {
        expect(await service.findByIdWorkout(1)).toEqual({
          id: 1,
          name: '달리기',
          icon: 'a',
        } as Workout);
      });

      it('요청이 왔을 때, 만약 DB에 데이터가 없다면, NotFoundWorkoutException을 던져야한다.', async () => {
        mockRepository.findOne = jest.fn().mockResolvedValue(undefined);
        await expect(service.findByIdWorkout(1)).rejects.toThrow(
          NotFoundWorkoutException,
        );
      });
    });
  });
});
