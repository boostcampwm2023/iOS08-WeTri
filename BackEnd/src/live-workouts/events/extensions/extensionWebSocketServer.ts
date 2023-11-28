import { WebSocket } from 'ws';

export class ExtensionWebSocketServer {
    rooms: Map<string, Set<string>>
    sids: Map<string, Set<string>>
    clientMap: Map<string, WebSocket>
    constructor(server: any) {
        server.rooms = new Map<string, Set<string>>
        server.sids = new Map<string, Set<string>>
        server.clientMap = new Map<string, WebSocket>
        server.joinRoom = this.joinRoom;
        server.leaveRoom = this.leaveRoom;
        server.to = this.to;
    }

    joinRoom(clientId: string, roomName: string) {
        if (!this.rooms.has(roomName)) {
            this.rooms.set(roomName, new Set());
        }
        if (!this.sids.has(clientId)) {
            this.sids.set(clientId, new Set());
        }
        this.rooms.get(roomName).add(clientId);
        this.sids.get(clientId).add(roomName);
        
    }

    leaveRoom(clientId: string, roomName: string) {
        if (this.rooms.has(roomName)) {
            this.rooms.get(roomName).delete(clientId);
        }
        if (this.sids.has(clientId)) {
            this.sids.get(clientId).delete(roomName);
        }
    }

    to(roomName: string) {
        return {
            emit: (event: string, message: string) => {
                if (this.rooms.has(roomName)) {
                    const room = this.rooms.get(roomName);
                    room.forEach((clientId) => {
                        this.clientMap[clientId].send(JSON.stringify({ event, message }));
                    });
                }
            },
        };
    }
}