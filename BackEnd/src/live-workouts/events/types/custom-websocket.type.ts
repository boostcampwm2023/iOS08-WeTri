import * as WebSocket from 'ws';
import { Profile } from '../../../profiles/entities/profiles.entity';

export interface WetriServer extends WebSocket.Server {
  clientMap: Map<string, WetriWebSocket>;
  rooms: Map<string, Set<string>>;
  sids: Map<string, Set<string>>;
  joinRoom: (clientId: string, roomName: string) => void;
  leaveRoom: (clientId: string, roomName: string) => void;
  to: (roomName: string) => { emit: (event: string, message: string) => void };
}

export interface WetriWebSocket extends WebSocket {
  id: string;
  server: WetriServer;
  join: (roomName: string) => void;
  leave: (roomName: string) => void;
  to: (roomName: string) => { emit: (event: string, message: string) => void };
  authorization?: string;
  profile?: Profile;
  token?: string;
  tokenType?: string;
}
