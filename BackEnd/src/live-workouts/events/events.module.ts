import { Module } from '@nestjs/common';
import { EventsService } from './events.service';
import { EventsGateway } from './events.gateway';
import { ExtensionWebSocketService } from './extensionWebSocket.service';

@Module({
  providers: [
    EventsGateway, 
    EventsService, 
    ExtensionWebSocketService
  ],
})
export class EventsModule {}
