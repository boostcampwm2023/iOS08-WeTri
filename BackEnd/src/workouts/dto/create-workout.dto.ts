import {PickType} from '@nestjs/swagger';
import {WorkoutModel} from "../entities/workout.entity";


export class CreateWorkoutDto extends PickType(WorkoutModel, [
    'name'
]){}
