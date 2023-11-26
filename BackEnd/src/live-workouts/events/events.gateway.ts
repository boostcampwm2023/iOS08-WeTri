import {
  WebSocketGateway,
  SubscribeMessage,
  MessageBody,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
} from '@nestjs/websockets';
import { Server, WebSocket } from 'ws';
import { EventsService } from './events.service';
import { CreateEventDto } from './dto/create-event.dto';
import { UpdateEventDto } from './dto/update-event.dto';
import { ExtensionWebSocketServer } from './Extensions/ExtensionServer';
import { ExtensionWebSocket } from './Extensions/ExtensionWebSocket';

@WebSocketGateway(3003)
export class EventsGateway implements OnGatewayInit {
  @WebSocketServer() server: Server;
  constructor(private readonly eventsService: EventsService) {}

  afterInit(server: any) {
      new ExtensionWebSocketServer(server);
  }

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
    new ExtensionWebSocket(client, this.server);
    client.join('room1');
    this.server.to('room1').emit('event_name', "새로운 유저가 room1에 참가하셨습니다.");
    console.log(`클라이언트 연결`);
  }

  handleDisconnect(client: WebSocket): void {
    console.log(`클라이언트 연결 종료`);
  }

  @SubscribeMessage('createEvent')
  create(@MessageBody() createEventDto: CreateEventDto) {
    return this.eventsService.create(createEventDto);
  }

  @SubscribeMessage('findAllEvents')
  findAll() {
    return this.eventsService.findAll();
  }

  @SubscribeMessage('findOneEvent')
  findOne(@MessageBody() id: number) {
    return this.eventsService.findOne(id);
  }

  @SubscribeMessage('updateEvent')
  update(@MessageBody() updateEventDto: UpdateEventDto) {
    return this.eventsService.update(updateEventDto.id, updateEventDto);
  }

  @SubscribeMessage('removeEvent')
  remove(@MessageBody() id: number) {
    return this.eventsService.remove(id);
  }
}
