import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { AppController } from './app.controller';
import { typeOrmConfig } from './config/typeorm.config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LoggerMiddleware } from './middlewares/logger.middleware';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { ProfilesModule } from './profiles/profiles.module';
import { RecordsModule } from './records/records.module';
import { WorkoutsModule } from './workouts/workouts.module';
import { EventsModule } from './live-workouts/events/events.module';
import { MatchesModule } from './live-workouts/matches/matches.module';
import { AdminModule } from './admin/admin.module';
import {ImagesModule} from "./images/images.module";
import {ConfigModule} from "@nestjs/config";
import { RedisModule } from './common/redis.module';

@Module({
  imports: [
    ConfigModule.forRoot({isGlobal: true}),
    TypeOrmModule.forRoot(typeOrmConfig),
    RedisModule,
    AuthModule,
    UsersModule,
    ProfilesModule,
    RecordsModule,
    WorkoutsModule,
    MatchesModule,
    EventsModule,
    AdminModule,
    ImagesModule,
  ],
  controllers: [AppController],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    consumer.apply(LoggerMiddleware).forRoutes('*');
  }
}
