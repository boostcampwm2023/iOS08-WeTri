import { Module } from '@nestjs/common';
import { EventsService } from './events.service';
import { EventsGateway } from './events.gateway';
import { ExtensionWebSocketService } from './extensionWebSocket.service';
import { JwtModule } from '@nestjs/jwt';
import { UsersModule } from '../../users/users.module';
import { ProfilesModule } from '../../profiles/profiles.module';
import { AuthController } from '../../auth/auth.controller';
import { AuthService } from '../../auth/auth.service';
import { AuthAppleService } from '../../auth/auth-apple.service';

@Module({
  imports: [JwtModule.register({}), UsersModule, ProfilesModule],
  controllers: [AuthController],
  providers: [
    EventsGateway,
    EventsService,
    ExtensionWebSocketService,
    AuthService,
    AuthAppleService,
  ],
})
export class EventsModule {}
