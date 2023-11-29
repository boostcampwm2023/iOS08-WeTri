import { Injectable } from '@nestjs/common';
import {
  RedisModuleOptions,
  RedisOptionsFactory,
} from '@songkeys/nestjs-redis';
import * as dotenv from 'dotenv';
import * as process from 'process';

dotenv.config();

export const redisConfig: object = {
  host: process.env.REDIS_HOST,
  port: parseInt(process.env.REDIS_PORT),
  enableReadyCheck: true,
  enableOfflineQueue: true,
}

// @Injectable()
// export class RedisConfigService implements RedisOptionsFactory {
//   createRedisOptions(): RedisModuleOptions {
//     return {
//       readyLog: true,
//       config: [
//         {
//           name: 'subscribe',
//           host: process.env.REDIS_HOST,
//           port: parseInt(process.env.REDIS_PORT),
//         }
//       ],
//     };
//   }
// }
