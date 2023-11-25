import {
  WebSocketGateway,
  SubscribeMessage,
  MessageBody,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import * as WebSocket from 'ws';
import { EventsService } from './events.service';
import { CreateEventDto } from './dto/create-event.dto';
import { UpdateEventDto } from './dto/update-event.dto';

@WebSocketGateway(3003)
export class EventsGateway {
  @WebSocketServer() server: WebSocket.Server;
  constructor(private readonly eventsService: EventsService) {}

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
