import { Injectable } from "@nestjs/common";
import { ExtensionWebSocketServer } from "./\bextensions/extensionWebSocketServer";
import { ExtensionWebSocket } from "./\bextensions/extensionWebSocket";

@Injectable()
export class ExtensionWebSocketService {
    
    webSocketServer(server: any) {
        new ExtensionWebSocketServer(server);
    }

    webSocket(client: WebSocket, server: any) {
        new ExtensionWebSocket(client, server);
    }
}