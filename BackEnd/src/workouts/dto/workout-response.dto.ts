import { ApiProperty, PickType } from '@nestjs/swagger';
import { SuccessResDto } from '../../common/dto/SuccessRes.dto';
import { Workout } from '../entities/workout.entity';

export class WorkoutResDto extends SuccessResDto {
  @ApiProperty({ type: () => PickType(Workout, ['id', 'name']) })
  data: Pick<Workout, 'id' | 'name'>;
}

export const WorkoutResDtoSwagger = () => {
  return {
    example: {
      code: null,
      errorMessage: null,
      data: [
        {
          id: 1,
          name: '달리기',
          icon: 'figure.outdoor.a',
        },
        {
          id: 2,
          name: '수영',
          icon: 'figure.outdoor.b',
        },
        {
          id: 3,
          name: '사이클',
          icon: 'figure.outdoor.c',
        },
      ]
    },
  };
};
