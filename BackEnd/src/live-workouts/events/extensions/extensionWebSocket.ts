import * as WebSocket from 'ws';
import { WetriServer, WetriWebSocket } from '../types/custom-websocket.type';

export class ExtensionWebSocket extends WebSocket {
  server: WetriServer;
  id: string;
  constructor(client: WetriWebSocket, server: WetriServer) {
    super(null);
    client.id = client.profile.publicId;
    client.server = server;
    client.join = this.join;
    client.leave = this.leave;
    client.to = this.to;
    client.wemit = this.wemit;
    client.server.clientMap.set(client.id, client);
    client.on('close', () => {
      if (client.server.sids.has(client.id)) {
        client.server.sids.get(client.id).forEach((roomId) => {
          client.leave(roomId);
          client.server.clientMap.delete(client.id);
        });
      }
    });
  }

  join(roomId: string) {
    this.server.joinRoom(this.id, roomId);
  }

  leave(roomId: string) {
    this.server.leaveRoom(this.id, roomId);
  }

  to(roomId: string) {
    return {
      emit: (event: string, message: string) => {
        this.server.to(roomId).emit(event, message, this.id);
      },
    };
  }

  wemit(event: string, message: string): boolean {
    this.send(JSON.stringify({ event, message }));
    return true;
  }
}
