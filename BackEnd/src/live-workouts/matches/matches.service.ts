import { Inject, Injectable, Logger } from '@nestjs/common';
import { Redis } from 'ioredis';
import { CreateMatchDto } from './dto/create-match.dto';
import { Profile } from '../../profiles/entities/profiles.entity';
import { v4 as uuidv4 } from 'uuid';
import { RandomMatchDto, RandomMatch } from './dto/random-match.dto';
import {
  MAX_USERS,
  WAITING_60_TIME,
  WAITING_40_TIME,
  USER_WAITED_20_MIN_USERS,
  USER_WAITED_40_MIN_USERS,
  USER_WAITED_60_MIN_USERS,
  MIN_USERS,
  WAITING_20_TIME,
  ALONE_USER,
  MATCHING_DELAY,
  UTC_REMOVE_TIME,
  MATCHES_API_TIME_OUT,
} from './constant/matches.constant';

@Injectable()
export class MatchesService {
  private readonly logger: Logger = new Logger(MatchesService.name);

  constructor(@Inject('DATA_REDIS') private readonly redis: Redis) {}
  async startMatch(
    profile: Profile,
    createMatchDto: CreateMatchDto,
  ): Promise<void> {
    const { publicId } = profile;
    const { workoutId } = createMatchDto;
    this.logger.log(`startMatch: ${publicId} ${workoutId}`);

    await this.initMatch(profile, workoutId);
    await this.redis.rpush(
      `matching:${workoutId}`,
      JSON.stringify(profile),
      'EX',
      MATCHES_API_TIME_OUT,
    );
  }

  async cancelMatch(
    profile: Profile,
    createMatchDto: CreateMatchDto,
  ): Promise<void> {
    const { publicId } = profile;
    const { workoutId } = createMatchDto;
    this.logger.log(`cancelMatch: ${publicId} ${workoutId}`);

    await this.initMatch(profile, workoutId);
  }

  async isRandomMatched(
    profile: Profile,
    randomMatchDto: RandomMatchDto,
  ): Promise<RandomMatch> {
    const { publicId } = profile;
    const { workoutId, waitingTime } = randomMatchDto;
    this.logger.log(`isRandomMatched: ${publicId} ${workoutId}`);

    const roomId: string = await this.redis.get(`userMatch:${publicId}`);
    if (roomId) {
      const serializedProfiles: string = await this.redis.get(
        `matchProfiles:${roomId}`,
      );
      const profiles: Profile[] = JSON.parse(serializedProfiles);
      const liveWorkoutStartTimeUTC: string = await this.redis.get(
        `matchStartTime:${roomId}`,
      );
      return {
        matched: true,
        roomId: roomId,
        liveWorkoutStartTime: liveWorkoutStartTimeUTC,
        peers: profiles,
      };
    }

    const waitingLength = await this.redis.llen(`matching:${workoutId}`);
    const waitingUsers = this.matchingAlgorithm(waitingLength, waitingTime);

    if (waitingUsers >= MIN_USERS) {
      return await this.makeWebSocketRoom(workoutId, waitingUsers);
    }
  }

  private async makeWebSocketRoom(
    workoutId: number,
    waitingUsers: number,
  ): Promise<RandomMatch> {
    const roomId: string = `match:${workoutId}:${uuidv4()}`;

    const serializedUsers: string[] = await this.redis.lrange(
      `matching:${workoutId}`,
      0,
      waitingUsers - 1,
    );
    const profiles: Profile[] = serializedUsers.map((serializedUser) =>
      JSON.parse(serializedUser),
    );

    const liveWorkoutStartTime = new Date();
    liveWorkoutStartTime.setSeconds(
        liveWorkoutStartTime.getSeconds() + 15,
    );
    const kstTime = new Date(liveWorkoutStartTime.getTime() + (9 * 60 * 60 * 1000));
    const liveWorkoutStartTimeUTC = kstTime.toISOString()
        .replace(/T/, ' ')
        .replace(/\..+/, '')
        .slice(0, 19);

    const multi = this.redis.multi();
    for (const { publicId } of profiles) {
      multi.set(`userMatch:${publicId}`, roomId, 'EX', MATCHES_API_TIME_OUT);
    }

    multi.set(
      `matchProfiles:${roomId}`,
      JSON.stringify(profiles),
      'EX',
      MATCHES_API_TIME_OUT,
    );
    multi.set(
      `matchStartTime:${roomId}`,
      JSON.stringify(liveWorkoutStartTimeUTC),
    );
    multi.expire(`matchStartTime:${roomId}`, UTC_REMOVE_TIME);
    multi.ltrim(`matching:${workoutId}`, waitingUsers, -1);
    await multi.exec();

    return {
      matched: true,
      roomId: roomId,
      liveWorkoutStartTime: liveWorkoutStartTimeUTC,
      peers: profiles,
    };
  }

  private matchingAlgorithm(queueLength: number, waitingTime: number) {
    if (queueLength >= MAX_USERS) {
      return MAX_USERS;
    } else if (
      waitingTime <= WAITING_20_TIME &&
      queueLength >= USER_WAITED_20_MIN_USERS
    ) {
      return USER_WAITED_20_MIN_USERS;
    } else if (
      waitingTime >= WAITING_40_TIME &&
      queueLength >= USER_WAITED_40_MIN_USERS
    ) {
      return USER_WAITED_40_MIN_USERS;
    } else if (
      waitingTime >= WAITING_60_TIME &&
      queueLength >= USER_WAITED_60_MIN_USERS
    ) {
      return USER_WAITED_60_MIN_USERS;
    }
    return ALONE_USER;
  }

  private async initMatch(profile: Profile, workoutId: number) {
    return Promise.all([
      this.redis.lrem(`matching:${workoutId}`, 0, JSON.stringify(profile)),
      this.redis.del(`userMatch:${profile.publicId}`),
    ]);
  }
}
