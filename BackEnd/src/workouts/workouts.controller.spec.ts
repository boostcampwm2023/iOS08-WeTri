import { Test, TestingModule } from '@nestjs/testing';
import { WorkoutsController } from './workouts.controller';
import { WorkoutsService } from './workouts.service';
import { Workout } from './entities/workout.entity';
import { NotFoundWorkoutException } from './exceptions/workouts.exception';
import { AccessTokenGuard } from '../auth/guard/bearerToken.guard';
import { ExecutionContext } from '@nestjs/common';

describe('WorkoutsController', () => {
  let controller: WorkoutsController;
  let service: WorkoutsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [WorkoutsController],
      providers: [
        {
          provide: WorkoutsService,
          useValue: {
            findAllWorkouts: jest
              .fn()
              .mockResolvedValue([
                { id: 1, name: '달리기', icon: 'a' } as Workout,
                { id: 2, name: '수영', icon: 'b' } as Workout,
                { id: 3, name: '사이클', icon: 'c' } as Workout,
              ]),
          },
        },
      ],
    })
      .overrideGuard(AccessTokenGuard)
      .useValue((context: ExecutionContext) => {
        return true;
      })
      .compile();

    controller = module.get<WorkoutsController>(WorkoutsController);
    service = module.get<WorkoutsService>(WorkoutsService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  describe('getAllWorkout', () => {
    it('요청을 하면 서비스에서는 배열 형태로, 리턴한다.', async () => {
      await expect(controller.getAllWorkout()).resolves.toEqual([
        { id: 1, name: '달리기', icon: 'a' } as Workout,
        { id: 2, name: '수영', icon: 'b' } as Workout,
        { id: 3, name: '사이클', icon: 'c' } as Workout,
      ]);
      expect(service.findAllWorkouts).toHaveBeenCalled();
    });

    it('만약, 빈 배열이라면, 서비스에서는 NotFoundWorkoutException을 던진다.', async () => {
      jest
        .spyOn(service, 'findAllWorkouts')
        .mockRejectedValue(new NotFoundWorkoutException());
      await expect(controller.getAllWorkout()).rejects.toThrow(
        NotFoundWorkoutException,
      );
    });
  });
});
