import { HttpException } from '@nestjs/common';

export class PublicIdMismatchException extends HttpException {
  constructor() {
    const response = {
      statusCode: 2030,
      message: 'misMatch',
    };
    const httpCode = 400;
    super(response, httpCode);
  }
}
