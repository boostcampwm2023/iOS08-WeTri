import { Server, WebSocket } from 'ws';
import { v4 as uuidv4 } from 'uuid';
export class ExtensionWebSocket {
  server: Server;
  id: string;
  constructor(client: WebSocket, server: Server) {
    client.id = uuidv4();
    client.server = server;
    client.join = this.join;
    client.leave = this.leave;
    client.to = this.to;
    this.server.clients[client.id] = client;
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
              this.server.clients[clientId].send(JSON.stringify({ event, message }));
            }
          });
        }
      },
    };
  }
}
