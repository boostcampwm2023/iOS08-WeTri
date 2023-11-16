import {Inject, Injectable, Logger, LoggerService, NestMiddleware} from '@nestjs/common';
import {Request, Response, NextFunction} from 'express';

@Injectable()
export class LoggerMiddleware implements NestMiddleware {
    constructor(@Inject(Logger) private readonly logger: LoggerService) {}

    use(request: Request, response: Response, next: NextFunction) {
        const { ip, method, originalUrl } = request;
        const userAgent = request.get('user-agent');

        request.on('finish', () => {
            const { statusCode } = response;
            this.logger.log(
                `${method} ${originalUrl} ${statusCode} ${ip} ${userAgent}`,
            );
        });

        next();
    }
}