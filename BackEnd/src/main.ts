import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { SwaggerSetting } from './config/swagger.config';
import { winstonLogger } from './config/winston.config';
import { ValidationPipe } from '@nestjs/common';
import { ResponseTransformInterceptor } from './common/Interceptors/responseTransform. Interceptor';
import { HttpExceptionFilter } from './common/exceptionFilters/httpException.filter';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    logger: winstonLogger,
  });
  app.useGlobalPipes(new ValidationPipe());
  app.useGlobalFilters(new HttpExceptionFilter);
  app.useGlobalInterceptors(new ResponseTransformInterceptor);
  SwaggerSetting(app);
  await app.listen(3000);
}
bootstrap();
