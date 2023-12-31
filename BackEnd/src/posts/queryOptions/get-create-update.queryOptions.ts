import { QueryOptions } from '../../common/type/query-options.type';

export const getCreateUpdateQueryOptions: QueryOptions = {
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
    'profile.profileImage',
  ],
};
