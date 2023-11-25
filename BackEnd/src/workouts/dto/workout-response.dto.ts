import { ApiProperty, PickType } from '@nestjs/swagger';
import { SuccessResDto } from '../../common/dto/SuccessRes.dto';
import { Workout } from '../entities/workout.entity';

export class WorkoutResDto extends SuccessResDto {
  @ApiProperty({ type: () => PickType(Workout, ['name']) })
  data: Pick<Workout, 'name'>;
}
