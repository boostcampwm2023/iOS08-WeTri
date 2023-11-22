import {HttpException} from '@nestjs/common';

export class NotFoundRecordException extends HttpException {
    constructor() {
        const response = {
            statusCode: 10400,
            message: 'no records.'
        };
        const httpCode = 404;
        super(response, httpCode);
    }
}