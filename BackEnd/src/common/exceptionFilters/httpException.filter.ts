import { ArgumentsHost, Catch, ExceptionFilter, HttpException } from "@nestjs/common";

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
    catch(exception: any, host: ArgumentsHost) {
        const ctx = host.switchToHttp();
        const response = ctx.getResponse();
        const status = exception.getStatus();
        const exceptionResponse = exception.getResponse();

        const errorMessage = exceptionResponse['message'];
        const statusCode = exceptionResponse['statusCode'];

        response
            .status(status)
            .json({
                code: statusCode,
                errorMessage,
                data: null,
            })
    }
}