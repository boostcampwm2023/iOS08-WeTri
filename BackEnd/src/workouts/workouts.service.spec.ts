import { Test, TestingModule } from '@nestjs/testing';
import { WorkoutsService } from './workouts.service';
import { Workout } from './entities/workout.entity';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

describe('WorkoutsService', () => {
    let service: WorkoutsService;
    let mockRepository: Partial<Repository<Workout>>;

    beforeEach(async () => {
        const mockWorkouts: Workout[] = [
            { id: 1, name: '달리기'} as Workout,
            { id: 2, name: '수영'} as Workout,
            { id: 3, name: '사이클'} as Workout,
        ];

        mockRepository = {
            find: jest.fn().mockResolvedValue(mockWorkouts),
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

    it('서비스의 findAllworkouts는 목 데이터를 동일하게 리턴해야한다.', async () => {
        expect(await service.findAllWorkouts()).toEqual([
            { id: 1, name: '달리기'} as Workout,
            { id: 2, name: '수영'} as Workout,
            { id: 3, name: '사이클'} as Workout,
        ]);
        expect(mockRepository.find).toHaveBeenCalled();
    });
});