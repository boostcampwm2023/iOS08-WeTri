import { Redis } from 'ioredis';
import { Inject, Injectable } from '@nestjs/common';
import { CheckMatchingDto } from './dto/checkMatching.dto';

@Injectable()
export class EventsService {
  constructor(@Inject('DATA_REDIS') private readonly redisData: Redis) {}

  async checkMatching(matchInfo: CheckMatchingDto) {
    const resultRoomId = await this.redisData.get(matchInfo.matchingKey);
    if (resultRoomId !== matchInfo.roomId) {
      return false;
    }
    return true;
  }

  checkMsgRoomId(data: any) {
    if (!data.roomId) {
      return false;
    }
    return true;
  }
}
