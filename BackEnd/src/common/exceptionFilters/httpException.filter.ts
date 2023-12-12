import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
} from '@nestjs/common';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const status = exception.getStatus();
    const exceptionResponse = exception.getResponse();

    let errorMessage = exceptionResponse['message'];
    let statusCode = exceptionResponse['statusCode'];
    if (typeof errorMessage !== 'string') {
      errorMessage = String(errorMessage);
    }
    let data = null;
    if(status === HttpStatus.OK) {
      data = exceptionResponse['data'];
    }
    response.status(status).json({
      code: statusCode,
      errorMessage,
      data,
    });
  }
}
