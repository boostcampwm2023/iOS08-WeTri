import { Redis } from 'ioredis';
import { Inject, Injectable } from '@nestjs/common';
import { WetriWebSocket } from './types/custom-websocket.type';
import { CheckMatchingDto } from './dto/checkMatching.dto';
import { AuthService } from 'src/auth/auth.service';
import { ProfilesService } from 'src/profiles/profiles.service';

@Injectable()
export class EventsService {
  constructor(
    @Inject('DATA_REDIS') private readonly redisData: Redis
    ) {}

  async checkMatching(matchInfo: CheckMatchingDto) {
    const resultUserExist = await this.redisData.exists(matchInfo.clientId);
    if(!resultUserExist) {
      return false;
    }
    const resultRoomExist = await this.redisData.get(matchInfo.roomId);
    if(!resultRoomExist) {
      return false;
    }
    return true;
  }
}
