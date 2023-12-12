import * as dotenv from 'dotenv';
import * as process from 'process';

dotenv.config();

export const redisConfig: object = {
  host: process.env.REDIS_HOST,
  port: parseInt(process.env.REDIS_PORT),
  enableReadyCheck: true,
  enableOfflineQueue: true,
};
