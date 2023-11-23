import { Module } from '@nestjs/common';
import { LiveGateway } from './lives.gateway';

@Module({
  providers: [LiveGateway],
})
export class LiveModule {}
