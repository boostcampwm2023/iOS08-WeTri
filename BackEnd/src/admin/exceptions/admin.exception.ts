import { HttpException } from '@nestjs/common';

export class NotFoundAdminIdException extends HttpException {
  constructor() {
    const response = {
      statusCode: 2000,
      message: 'not found account error',
    };
    const httpCode = 404;
    super(response, httpCode);
  }
}

export class IncorrectPasswordException extends HttpException {
  constructor() {
    const response = {
      statusCode: 2005,
      message: 'password is incorrect',
    };
    const httpCode = 400;
    super(response, httpCode);
  }
}
