import { HttpException } from '@nestjs/common';

export class ExistPostException extends HttpException {
  constructor() {
    const response = {
      statusCode: 8130,
      message: 'post already exists',
    };
    const httpCode = 400;
    super(response, httpCode);
  }
}

export class NotFoundPostException extends HttpException {
  constructor() {
    const response = {
      statusCode: 8000,
      message: 'not found post error',
    };
    const httpCode = 404;
    super(response, httpCode);
  }
}
