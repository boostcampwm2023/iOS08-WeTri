import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import {
  RandomMatchDto,
  RandomMatch,
  RandomMatchResDto,
  randomNoMatchingResDto,
} from './random-match.dto';

describe('RandomMatchDto', () => {
  it('workoutId와 waitingTime를 둘다 가질 경우에는 오류가 발생하지 않는다.', async () => {
    const dto = plainToInstance(RandomMatchDto, {
      workoutId: 1,
      waitingTime: 60,
    });
    const errors = await validate(dto);
    expect(errors.length).toBe(0);
  });

  it('workoutId와 waitingTime를 둘 중 한개라도 숫자가 아닌 경우에는 오류가 발생한다.', async () => {
    const dto = plainToInstance(RandomMatchDto, {
      workoutId: '진',
      waitingTime: '육백만초',
    });
    const errors = await validate(dto);
    expect(errors.length).toBeGreaterThan(0);
  });

  it('만약 값이 비어있다면, 오류가 발생한다.', async () => {
    const dto = plainToInstance(RandomMatchDto, {});
    const errors = await validate(dto);
    expect(errors.length).toBeGreaterThan(0);
  });
});

describe('RandomMatchResDto', () => {
  it('만약 매칭이 잡힌 경우, true를 리턴한다.', async () => {
    const resDto = plainToInstance(RandomMatchResDto, {
      data: { matched: true },
    });
    const errors = await validate(resDto);
    expect(errors.length).toBe(0);
  });
});
