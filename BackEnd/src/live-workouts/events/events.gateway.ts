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
export class EventsGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() server: WebSocket.Server;
  constructor(private readonly eventsService: EventsService) {}

  handleDisconnect(client: any) {
    throw new Error('Method not implemented.');
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

  handleConnection(client: any, ...args: any[]): any {}
}
