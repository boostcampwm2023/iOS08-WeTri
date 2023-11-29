import { Injectable } from '@nestjs/common';

import { WetriServer, WetriWebSocket } from './types/custom-websocket.type';
import { ExtensionWebSocket } from './extensions/extensionWebSocket';
import { ExtensionWebSocketServer } from './extensions/extensionWebSocketServer';

@Injectable()
export class ExtensionWebSocketService {
  webSocketServer(server: WetriServer) {
    new ExtensionWebSocketServer(server);
  }

  webSocket(client: WetriWebSocket, server: WetriServer) {
    new ExtensionWebSocket(client, server);
  }
}
