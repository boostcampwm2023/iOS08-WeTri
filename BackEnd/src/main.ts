import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { SwaggerSetting } from './config/swagger.config';
import { ValidationPipe } from '@nestjs/common';
import { ResponseTransformInterceptor } from './common/Interceptors/responseTransform. Interceptor';
import { HttpExceptionFilter } from './common/exceptionFilters/httpException.filter';
import { WsAdapter } from '@nestjs/platform-ws';
import * as express from 'express';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(new ValidationPipe({
    transform: true,
    transformOptions: {
      enableImplicitConversion: true,
    }
  }));
  app.useGlobalFilters(new HttpExceptionFilter());
  app.useGlobalInterceptors(new ResponseTransformInterceptor());
  app.useWebSocketAdapter(new WsAdapter(app));
  app.use('/static', express.static('public'));
  SwaggerSetting(app);
  await app.listen(3000);
}
bootstrap();
