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
@WebSocketGateway(3003)
export class EventsGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() server: WetriServer;
  constructor(
    private readonly eventsService: EventsService,
    private readonly extensionWebSocketService: ExtensionWebSocketService,
  ) {}

  afterInit(server: WetriServer) {
    this.extensionWebSocketService.webSocketServer(server);
  }

  handleConnection(client: WetriWebSocket, ...args: any[]): any {
    this.extensionWebSocketService.webSocket(client, this.server);
    client.join('room1');
    this.server.to('room1').emit('event', 'message');
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

  handleDisconnect(client: any) {
    // throw new Error('Method not implemented.');
  }
}
