import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { CreateMatchDto } from './create-match.dto';

describe('CreateMatchDto', () => {
  it('workoutId가 숫자일 때, 에러는 발생하지 않는다.', async () => {
    const dto = plainToInstance(CreateMatchDto, { workoutId: 1 });
    const errors = await validate(dto);
    expect(errors.length).toBe(0);
  });

  it('workoutId가 문자로 들어왔을 때, 에러가 발생한다.', async () => {
    const dto = plainToInstance(CreateMatchDto, { workoutId: '닌자' });
    const errors = await validate(dto);
    expect(errors.length).toBeGreaterThan(0);
  });

  it('만약 dto가 비어 있다면, 에러가 발생한다.', async () => {
    const dto = plainToInstance(CreateMatchDto, {});
    const errors = await validate(dto);
    expect(errors.length).toBeGreaterThan(0);
  });
});
