import { WorkoutResDto } from './workout-response.dto';
import { Workout } from '../entities/workout.entity';

describe('WorkoutResDto', () => {
  it('WorkoutResDto는 배열을 리턴하며 내부에는 id, name, icon이 존재한다.', () => {
    const workout1 = new Workout();
    workout1.id = 1;
    workout1.name = '달리기';
    workout1.icon = 'running.svg';

    const workout2 = new Workout();
    workout2.id = 2;
    workout2.name = '수영';
    workout2.icon = 'swimming.svg';

    const dto = new WorkoutResDto();
    dto.data = [workout1, workout2];

    expect(dto.data).toBeInstanceOf(Array);
    expect(dto.data[0]).toBeInstanceOf(Workout);
    expect(dto.data[0].name).toBe('달리기');
    expect(dto.data[1].name).toBe('수영');
    expect(dto.data[1].icon).toBe('swimming.svg');
  });
});
