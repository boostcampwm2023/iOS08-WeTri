import {
  WebSocketGateway,
  SubscribeMessage,
  MessageBody,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
} from '@nestjs/websockets';
import * as WebSocket from 'ws';
import { EventsService } from './events.service';
import { ExtensionWebSocketService } from './extensionWebSocket.service';
import { WetriWebSocket, WetriServer } from './types/custom-websocket.type';
import { AuthService } from '../../auth/auth.service';
import { CheckMatchingDto } from './dto/checkMatching.dto';
import { Logger } from '@nestjs/common';

@WebSocketGateway(3003)
export class EventsGateway
  implements OnGatewayConnection, OnGatewayDisconnect, OnGatewayInit
{
  @WebSocketServer() server: WetriServer;
  constructor(
    private readonly authService: AuthService,
    private readonly eventsService: EventsService,
    private readonly extensionWebSocketService: ExtensionWebSocketService,
  ) {}

  afterInit(server: WetriServer): any {
    this.extensionWebSocketService.webSocketServer(server);
  }

  async handleConnection(client: WetriWebSocket, ...args: any[]) {
    const { authorization, roomid } = args[0].headers;
    if (!(await this.authService.verifyWs(authorization, client))) {
      client.close();
      return;
    }
    const matchInfo: CheckMatchingDto = {
      matchingKey: `userMatch:${client.id}`,
      roomId: roomid,
    };
    const resultCheckMatching =
      await this.eventsService.checkMatching(matchInfo);
    if (!resultCheckMatching) {
      client.close();
      return;
    }
    this.extensionWebSocketService.webSocket(client, this.server);
    client.join(roomid);
  }

  @SubscribeMessage('workout_session')
  onWorkoutSession(client: WetriWebSocket, data: any): void {
    if (!this.eventsService.checkMsgRoomId(data)) {
      client.wemit('workout_session', 'data에 roomId를 포함시켜주세요.');
    } else {
      if (this.server.sids.get(client.id).has(data.roomId)) {
        this.server
          .to(data.roomId)
          .emit('workout_session', JSON.stringify(data));
      }
    }
  }

  handleDisconnect(client: any) {}
}
