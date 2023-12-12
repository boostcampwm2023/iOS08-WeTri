import { Redis } from 'ioredis';
import { WetriServer, WetriWebSocket } from '../types/custom-websocket.type';
import { Logger } from '@nestjs/common';

export class ExtensionWebSocketServer {
  rooms: Map<string, Set<string>>;
  sids: Map<string, Set<string>>;
  clientMap: Map<string, WetriWebSocket>;
  redisData: Redis;
  redisSubscribe: Redis;
  constructor(server: WetriServer, redisData: Redis, redisSubscribe: Redis) {
    server.rooms = new Map<string, Set<string>>();
    server.sids = new Map<string, Set<string>>();
    server.clientMap = new Map<string, WetriWebSocket>();
    server.redisData = redisData;
    server.redisSubscribe = redisSubscribe;
    server.joinRoom = this.joinRoom;
    server.leaveRoom = this.leaveRoom;
    server.to = this.to;
    server.subscribe = this.subscribe;
    server.unSubscribe = this.unSubscribe;
    server.handlePublishMessage = this.handlePublishMessage;
    server.handlePublishMessage();
    process.on('exit', () => {
      server.sids.forEach((value, key) => {
        value.forEach(async (value) => {
          await redisData.srem(value, key);
        });
      });
    });
    process.on('SIGINT', () => process.exit());
    process.on('SIGTERM', () => process.exit());
    process.on('uncaughtException', () => process.exit());
  }

  async joinRoom(clientId: string, roomId: string) {
    if (!this.rooms.has(roomId)) {
      this.rooms.set(roomId, new Set());
    }
    if (this.rooms.get(roomId).size === 0) {
      this.subscribe(`channel/${roomId}`);
    }
    if (!this.sids.has(clientId)) {
      this.sids.set(clientId, new Set());
    }
    this.rooms.get(roomId).add(clientId);
    this.sids.get(clientId).add(roomId);
    await this.redisData.sadd(roomId, clientId);
  }

  async leaveRoom(clientId: string, roomId: string) {
    if (this.rooms.has(roomId)) {
      const curRoom = this.rooms.get(roomId);
      curRoom.delete(clientId);
      await this.redisData.srem(roomId, clientId);
      await this.redisData.del(`userMatch:${clientId}`);
      if (curRoom.size === 0) {
        this.unSubscribe(`channel/${roomId}`);
      }
    }
    if (this.sids.has(clientId)) {
      this.sids.get(clientId).delete(roomId);
    }
  }

  to(roomId: string) {
    return {
      emit: (event: string, message: string, issuedClientId?: string) => {
        const jsonMessage = { event, message };
        if (issuedClientId !== undefined) {
          jsonMessage['issuedClientId'] = issuedClientId;
        }
        if (this.rooms.has(roomId)) {
          this.redisData.publish(
            `channel/${roomId}`,
            JSON.stringify(jsonMessage),
          );
        }
      },
    };
  }

  async subscribe(channel: string) {
    await this.redisSubscribe.subscribe(channel, (error, count) => {
      if (error) {
        Logger.log('구독 오류');
      }
      Logger.log(`구독 성공: ${channel}, 현재 구독 중인 채널 수: ${count}`);
    });
  }

  handlePublishMessage() {
    this.redisSubscribe.on('message', (channel, message) => {
      const chSplit = channel.split('/');
      if (chSplit.length !== 2) {
        return;
      }
      const roomId = chSplit[1];
      if (!this.rooms.has(roomId)) {
        return;
      }
      const room = this.rooms.get(roomId);
      const jsonMessage = JSON.parse(message);
      const issuedClientId: string | undefined = jsonMessage.issuedClientId;
      if (issuedClientId && !this.sids.get(issuedClientId).has(roomId)) {
        return;
      }
      room.forEach((clientId) => {
        if (clientId !== issuedClientId) {
          const client = this.clientMap.get(clientId);
          client.send(
            JSON.stringify({
              event: jsonMessage.event,
              data: JSON.parse(jsonMessage.message),
            }),
          );
        }
      });
    });
  }

  async unSubscribe(channel: string) {
    await this.redisSubscribe.unsubscribe(channel);
    Logger.log(`구독 취소됨: ${channel}`);
  }
}
