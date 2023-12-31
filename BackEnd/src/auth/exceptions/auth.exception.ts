//auth와 관련된 exception을 모아둔 파일
import { HttpException, HttpStatus } from '@nestjs/common';

export class NicknameDuplicateException extends HttpException {
  constructor() {
    const response = {
      statusCode: 2010,
      message: 'duplicated nickname error.',
    };
    const httpCode = 400;
    super(response, httpCode);
  }
}

export class NotRefreshTokenException extends HttpException {
  constructor() {
    const response = {
      statusCode: 1080,
      message: 'this token is not refresh token.',
    };
    const httpCode = 400;
    super(response, httpCode);
  }
}

export class NotAccessTokenException extends HttpException {
  constructor() {
    const response = {
      statusCode: 1085,
      message: 'this token is not access token.',
    };
    const httpCode = 400;
    super(response, httpCode);
  }
}

export class InvalidTokenException extends HttpException {
  constructor() {
    const response = {
      statusCode: 1030,
      message: 'invalid sign up token error.',
    };
    const httpCode = 400;
    super(response, httpCode);
  }
}

export class NotExistToken extends HttpException {
  constructor() {
    const response = { statusCode: 1100, message: 'token does not exist.' };
    const httpCode = 404;
    super(response, httpCode);
  }
}

export class VerificationFailedIdentityToken extends HttpException {
  constructor() {
    const response = { statusCode: 1020, message: 'apple login error.' };
    const httpCode = 400;
    super(response, httpCode);
  }
}

export class NotFirstLoginException extends HttpException {
  constructor(data) {
    const response = { statusCode: null, message: null, data };
    super(response, HttpStatus.OK);
  }
}

export class NicknameDuplicate202Exception extends HttpException {
  constructor() {
    const response = {
      statusCode: null,
      message: null,
    };
    const httpCode = 202;
    super(response, httpCode);
  }
}
