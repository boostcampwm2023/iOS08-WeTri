import { HttpException } from '@nestjs/common';

export class NotAccessToNCPException extends HttpException {
  constructor() {
    const response = {
      statusCode: 9000,
      message: 'not Access',
    };
    const httpCode = 404;
    super(response, httpCode);
  }
}
export class NotAccessToGreenEyeException extends HttpException {
  constructor() {
    const response = {
      statusCode: 9100,
      message: 'not Access',
    };
    const httpCode = 404;
    super(response, httpCode);
  }
}

export class FileSizeTooLargeException extends HttpException {
  constructor() {
    const response = {
      statusCode: 9200,
      message: 'file size too large',
    };
    const httpCode = 400;
    super(response, httpCode);
  }
}

export class InvalidFileTypeException extends HttpException {
  constructor() {
    const response = {
      statusCode: 9300,
      message: 'invalid file type',
    };
    const httpCode = 400;
    super(response, httpCode);
  }
}

export class InvalidFileCountOrFieldNameException extends HttpException {
  constructor() {
    const response = {
      statusCode: 9400,
      message: 'invalid file count or field name',
    };
    const httpCode = 400;
    super(response, httpCode);
  }
}
