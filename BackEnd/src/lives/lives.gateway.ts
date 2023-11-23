import {
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import * as WebSocket from 'ws';

@WebSocketGateway(3003)
export class LiveGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() server: WebSocket.Server;

  @SubscribeMessage('events')
  onEvent(client: WebSocket, data: any): void {
    console.log(`전송받은 데이터: ${data}`);
    this.server.clients.forEach((others: WebSocket) => {
      if (others.readyState === WebSocket.OPEN) {
        others.send(data);
      }
    });
  }

  handleConnection(client: WebSocket): void {
    console.log(`클라이언트 연결`);
  }

  handleDisconnect(client: WebSocket): void {
    console.log(`클라이언트 연결 종료`);
  }
}
