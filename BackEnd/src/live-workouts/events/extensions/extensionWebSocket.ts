import * as WebSocket from 'ws';
import { v4 as uuidv4 } from 'uuid';
import { WetriServer, WetriWebSocket } from '../types/custom-websocket.type';
import { Injectable } from '@nestjs/common';

@Injectable()
export class ExtensionWebSocket {
  server: WetriServer;
  id: string;
  constructor(client: WetriWebSocket, server: WetriServer) {
    client.id = uuidv4();
    client.server = server;
    client.join = this.join;
    client.leave = this.leave;
    client.to = this.to;
    client.server.clientMap.set(client.id, client);
    // client.on('close', () => {
    //   if (client.server.sids.has(client.id)) {
    //     client.server.sids.get(client.id).forEach((roomName) => {
    //       client.leave(roomName);
    //     });
    //   }
    // });
  }

  join(roomName: string) {
    this.server.joinRoom(this.id, roomName);
  }

  leave(roomName: string) {
    this.server.leaveRoom(this.id, roomName);
  }

  to(roomName: string) {
    return {
      emit: (event: string, message: string) => {
        if (
          this.server.rooms.has(roomName) &&
          this.server.rooms.get(roomName).has(this.id)
        ) {
          const room = this.server.rooms.get(roomName);
          room.forEach((clientId) => {
            if (clientId !== this.id) {
              this.server.clientMap
                .get(clientId)
                .send(JSON.stringify({ event, message }));
            }
          });
        }
      },
    };
  }
}
