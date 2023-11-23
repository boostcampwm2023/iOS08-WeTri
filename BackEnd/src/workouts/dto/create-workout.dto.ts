import {PickType} from '@nestjs/swagger';
import {Workout} from "../entities/workout.entity";


export class CreateWorkoutDto extends PickType(Workout, [
    'name'
]){}
