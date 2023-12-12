import { Workout } from './workout.entity';
import { validate } from 'class-validator';

describe('Workout Entity', () => {
  it('Workout에서 id, name, icon이 엔티티에 정의한대로 올바르면, 에러가 발생하지 않는다.', async () => {
    const workout = new Workout();
    workout.id = 1;
    workout.name = '달리기';
    workout.icon = 'running';

    const errors = await validate(workout);
    expect(errors).toHaveLength(0);
  });

  it('Workout에서 name이 공백이면, 에러가 발생한다.', async () => {
    const workout = new Workout();
    workout.id = 1;
    workout.name = '';
    workout.icon = 'running';

    const errors = await validate(workout);
    expect(errors).toHaveLength(1);
  });

  it('Workout에서 icon이 공백이면, 에러가 발생한다.', async () => {
    const workout = new Workout();
    workout.id = 1;
    workout.name = '달리기';
    workout.icon = '';

    const errors = await validate(workout);
    expect(errors).toHaveLength(1);
  });
});
