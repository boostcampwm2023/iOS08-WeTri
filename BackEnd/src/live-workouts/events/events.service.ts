import { Redis } from 'ioredis';
import { Inject, Injectable } from '@nestjs/common';
import { WetriWebSocket } from './types/custom-websocket.type';
import { CheckMatchingDto } from './dto/checkMatching.dto';
import { AuthService } from 'src/auth/auth.service';
import { ProfilesService } from 'src/profiles/profiles.service';

@Injectable()
export class EventsService {
  constructor(@Inject('DATA_REDIS') private readonly redisData: Redis) {}

  async checkMatching(matchInfo: CheckMatchingDto) {
    const resultUserId = await this.redisData.get(matchInfo.clientId);
    if (!resultUserId) {
      return false;
    }
    if (resultUserId !== matchInfo.roomId) {
      return false;
    }
    return true;
  }
}
