import { HttpException } from "@nestjs/common";

export class NotFoundUserException extends HttpException {
    constructor() {
        const response = {
            statusCode: 2000,
            message: 'not found account error'
        };
        const httpCode = 404;
        super(response, httpCode);
    }
}