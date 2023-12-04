import { Module } from '@nestjs/common';
import { CommonService } from './common.service';

@Module({
  controllers: [],
  exports: [CommonService],
  providers: [CommonService],
})
export class CommonModule {}
