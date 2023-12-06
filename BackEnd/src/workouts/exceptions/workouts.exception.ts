import { HttpException } from '@nestjs/common';

export class NotFoundAllWorkoutsException extends HttpException {
  constructor() {
    const response = {
      statusCode: 3000,
      message: 'not found All Workouts error.',
    };
    const httpCode = 404;
    super(response, httpCode);
  }
}
export class NotFoundWorkoutException extends HttpException {
  constructor() {
    const response = {
      statusCode: 3100,
      message: 'not found Workout error.',
    };
    const httpCode = 404;
    super(response, httpCode);
  }
}