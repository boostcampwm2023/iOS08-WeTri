import * as dotenv from 'dotenv';

dotenv.config();

interface RedisConfig {
    host: string;
    port: number;
}

export const redisConfig: RedisConfig = {
    host: process.env.REDIS_HOST,
    port: parseInt(process.env.REDIS_PORT),
}