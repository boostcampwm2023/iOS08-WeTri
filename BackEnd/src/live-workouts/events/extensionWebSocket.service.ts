import { Redis } from 'ioredis';
import { Inject, Injectable } from '@nestjs/common';

import { WetriServer, WetriWebSocket } from './types/custom-websocket.type';
import { ExtensionWebSocket } from './extensions/extensionWebSocket';
import { ExtensionWebSocketServer } from './extensions/extensionWebSocketServer';

@Injectable()
export class ExtensionWebSocketService {
  constructor(
    @Inject('DATA_REDIS') private readonly redisData: Redis,
    @Inject('SUBSCRIBE_REDIS') private readonly redisSubscribe: Redis,
  ) {}

  webSocketServer(server: WetriServer) {
    new ExtensionWebSocketServer(server, this.redisData, this.redisSubscribe);
  }

  webSocket(client: WetriWebSocket, server: WetriServer) {
    new ExtensionWebSocket(client, server);
  }
}
