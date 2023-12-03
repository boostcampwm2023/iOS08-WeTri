import { HttpException } from "@nestjs/common";

export class ExistPostException extends HttpException {
    constructor() {
        const response = {
            statusCode: 8130,
            message: 'post already exists'
        };
        const httpCode = 400;
        super(response, httpCode)
    }
}