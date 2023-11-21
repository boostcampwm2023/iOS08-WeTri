import { Module } from '@nestjs/common';
import { RecordsService } from './records.service';
import { RecordsController } from './records.controller';

@Module({
  controllers: [RecordsController],
  providers: [RecordsService],
})
export class RecordsModule {}
