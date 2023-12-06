import {HttpException} from "@nestjs/common";

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
