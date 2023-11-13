import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import {typeOrmConfig} from "./config/typeorm.config";
import {TypeOrmModule} from "@nestjs/typeorm";

@Module({
  imports: [
        TypeOrmModule.forRootAsync(typeOrmConfig),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
