import { Module, Global } from '@nestjs/common';
import Redis from 'ioredis';
import { redisConfig } from 'src/config/redis.config';

@Global()
@Module({
  providers: [
    {
      provide: 'DATA_REDIS',
      useFactory: () => {
        return new Redis(redisConfig);
      },
    },
    {
      provide: 'SUBSCRIBE_REDIS',
      useFactory: () => {
        return new Redis(redisConfig);
      },
    },
  ],
  exports: ['DATA_REDIS', 'SUBSCRIBE_REDIS'],
})
export class RedisModule {}
