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
import { ProfilesService } from '../../profiles/profiles.service';
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
    const { authorization, roomId } = args[0].headers;
    if (!(await this.authService.verifyWs(authorization, client))) {
      client.close();
      return;
    }
    const matchInfo: CheckMatchingDto = {clientId: client.id, roomId };
    const resultCheckMatching = await this.eventsService.checkMatching(matchInfo);
    if(!resultCheckMatching) {
      client.close();
      return;
    }
    this.extensionWebSocketService.webSocket(client, this.server);
  }

  @SubscribeMessage('workout_session')
  onWorkoutSession(client: WetriWebSocket, data: any,): void {
    Logger.log(`전송받은 데이터: ${data}`);
  }

  handleDisconnect(client: any) {}
}
