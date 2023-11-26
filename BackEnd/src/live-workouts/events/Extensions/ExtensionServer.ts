import { Server , WebSocket } from 'ws';

export class ExtensionWebSocketServer {
    rooms: Map<string, Set<WebSocket>> = new Map();

    constructor(server: Server) {
        server.rooms = this.rooms;
    }

    joinRoom(client: WebSocket, roomName: string) {
        if(!this.rooms.has(roomName)) {
            this.rooms.set(roomName, new Set());
        }
        this.rooms.get(roomName).add(client);
    }

    leaveRoom(client: WebSocket, roomName: string) {
        if(this.rooms.has(roomName)) {
            this.rooms.get(roomName).delete(client);
        }
    }
}