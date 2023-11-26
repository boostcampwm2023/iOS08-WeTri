import { Server, WebSocket } from 'ws';
export class ExtensionWebSocket {
  server: Server;
  constructor(client: WebSocket, server: Server) {
    client.server = server;
    client.join = this.join;
    client.leave = this.leave;
    client.to = this.to;
  }

  join(roomName: string) {
    this.server.joinRoom(this, roomName);
  }

  leave(roomName: string) {
    this.server.leaveRoom(this, roomName);
  }

  to(roomName: string) {
    return {
      emit: (event: string, message: string) => {
        if (
          this.server.rooms.has(roomName) &&
          this.server.rooms.get(roomName).has(this)
        ) {
          const room = this.server.rooms.get(roomName);
          room.forEach((client) => {
            if (client !== this) {
              client.send(JSON.stringify({ event, message }));
            }
          });
        }
      },
    };
  }
}
