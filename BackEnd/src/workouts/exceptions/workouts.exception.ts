import { HttpException } from "@nestjs/common";

export class NotFoundWorkoutException extends HttpException {
    constructor() {
        const response = {
            statusCode: 3000,
            message: "not found category error.",
        }
        const httpCode = 404;
        super(response, httpCode);
    }
}