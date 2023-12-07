import { BasePaginationDto } from '../dto/base-pagination.dto';
import { QueryOptions } from '../../common/type/query-options.type';
import { Profile } from '../../profiles/entities/profiles.entity';

export const mockPaginationDto: BasePaginationDto = {
  order__createdAt: 'DESC',
  take: 5,
  where__id__less_then: 7,
};
export const profile = {
  publicId: 'XVZXC-ASFSA123-ASFSF',
  nickname: 'testNickname',
} as Profile;

export const mockItems = [
  {
    id: 6,
    publicId: profile.publicId,
    content: '안녕하세요 누구 누구 입니다.',
    like: null,
    createdAt: new Date('2023-12-04T05:14:15.879Z'),
    updatedAt: new Date('2023-12-04T05:14:15.879Z'),
    deletedAt: null,
    postUrl: 'https://www.naver.com',
    record: {
      id: 2,
      workoutTime: 6000000,
      distance: 100000,
      calorie: 360,
      avgHeartRate: 60,
      minHeartRate: 120,
      maxHeartRate: 180,
    },
    profile: {
      nickname: profile.nickname,
    },
  },
  {
    id: 5,
    publicId: profile.publicId,
    content: '수정한 내용입니다.',
    like: null,
    createdAt: new Date('2023-12-03T13:47:08.677Z'),
    updatedAt: new Date('2023-12-04T12:44:44.000Z'),
    deletedAt: null,
    postUrl: 'google.com',
    record: {
      id: 1,
      workoutTime: 100,
      distance: 100,
      calorie: 100,
      avgHeartRate: 100,
      minHeartRate: 100,
      maxHeartRate: 100,
    },
    profile: {
      nickname: profile.nickname,
    },
  },
];

export const mockGetCreateUpdateQueryOptions: QueryOptions = {
  mainAlias: 'post',
  joins: [
    {
      joinColumn: 'post.record',
      joinAlias: 'record',
    },
    {
      joinColumn: 'post.profile',
      joinAlias: 'profile',
    },
  ],
  selects: [
    'post',
    'record.id',
    'record.workoutTime',
    'record.distance',
    'record.calorie',
    'record.avgHeartRate',
    'record.minHeartRate',
    'record.maxHeartRate',
    'profile.nickname',
  ],
};
