import { Redis } from 'ioredis';
import * as WebSocket from 'ws';
import { Profile } from '../../../profiles/entities/profiles.entity';

export interface WetriServer extends WebSocket.Server {
  clientMap: Map<string, WetriWebSocket>;
  rooms: Map<string, Set<string>>;
  sids: Map<string, Set<string>>;
  redisData: Redis;
  redisSubscribe: Redis;
  joinRoom: (clientId: string, roomId: string) => void;
  leaveRoom: (clientId: string, roomId: string) => void;
  to: (roomId: string) => {
    emit: (event: string, message: string, issuedClientId?: string) => void;
  };
  subscribe: (channel: string) => void;
  unSubscribe: (channel: string) => void;
  handlePublishMessage: () => void;
}

export interface WetriWebSocket extends WebSocket {
  id: string;
  server: WetriServer;
  join: (roomId: string) => void;
  leave: (roomId: string) => void;
  to: (roomId: string) => { emit: (event: string, message: string) => void };
  authorization?: string;
  profile?: Profile;
  token?: string;
  tokenType?: string;
}
