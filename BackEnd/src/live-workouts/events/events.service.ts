import { Redis } from 'ioredis';
import { Inject, Injectable } from '@nestjs/common';
import { CheckMatchingDto } from './dto/checkMatching.dto';
import { WetriWebSocket } from './types/custom-websocket.type';

@Injectable()
export class EventsService {
  constructor(@Inject('DATA_REDIS') private readonly redisData: Redis) {}

  async checkMatching(matchInfo: CheckMatchingDto) {
    const resultUserId = await this.redisData.get(matchInfo.matchingKey);
    if (!resultUserId) {
      return false;
    }
    if (resultUserId !== matchInfo.roomId) {
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
