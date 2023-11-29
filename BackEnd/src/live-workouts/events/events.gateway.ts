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
import { CreateEventDto } from './dto/create-event.dto';
import { UpdateEventDto } from './dto/update-event.dto';
import { ExtensionWebSocketService } from './extensionWebSocket.service';
import { WetriWebSocket, WetriServer } from './types/custom-websocket.type';
import { AuthService } from '../../auth/auth.service';
import { ProfilesService } from '../../profiles/profiles.service';

@WebSocketGateway(3003)
export class EventsGateway
  implements OnGatewayConnection, OnGatewayDisconnect, OnGatewayInit
{
  @WebSocketServer() server: WetriServer;
  constructor(
    private readonly authService: AuthService,
    private readonly profilesService: ProfilesService,
    private readonly eventsService: EventsService,
    private readonly extensionWebSocketService: ExtensionWebSocketService,
  ) {}

  afterInit(server: WetriServer): any {
    this.extensionWebSocketService.webSocketServer(server);
  }

  async handleConnection(client: WetriWebSocket, ...args: any[]) {
    const { authorization } = args[0].headers;
    if (!(await this.jwtVerify(authorization, client))) {
      client.close();
      return;
    }
    this.extensionWebSocketService.webSocket(client, this.server);
  }

  private async jwtVerify(authorization: string, client: WetriWebSocket) {
    if (!authorization) {
      return false;
    }

    const token = this.authService.extractTokenFromHeader(authorization);
    const decoded = await this.authService.verifyToken(token);

    if (!decoded) {
      return false;
    }

    const profile = await this.profilesService.findByPublicId(decoded.sub);

    if (!profile) {
      return false;
    }

    client.profile = profile;
    client.token = token;
    client.tokenType = decoded.type;

    return true;
  }

  @SubscribeMessage('events')
  onEvent(client: WetriWebSocket, data: any): void {
    console.log(`전송받은 데이터: ${data}`);
    this.server.clients.forEach((others: WebSocket) => {
      if (others.readyState === WebSocket.OPEN) {
        others.send(data);
      }
    });
  }

  handleDisconnect(client: any) {}
}
