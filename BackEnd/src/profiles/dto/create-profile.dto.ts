import { Profile } from '../entities/profiles.entity';
import { PickType } from '@nestjs/swagger';
import { Post } from '../../posts/entities/posts.entity';

export class GetResPostUrl extends PickType(Post, ['id', 'postUrl']) {}

class GetResProfile extends PickType(Profile, [
  'nickname',
  'gender',
  'birthdate',
  'publicId',
  'profileImage',
]) {}

export const GetProfileAndPosts = () => {
  return {
    example: {
      code: null,
      errorMessage: null,
      data: {
        profile: {
          nickname: '닉네임',
          gender: '남자',
          birthdate: '2021-01-01',
          publicId: 'adsd2daw-ad2dawd-q1323123',
          profileImage:
            'https://s3.ap-northeast-2.amazonaws.com/recordapp/adsd2daw-ad2dawd-q1323123',
        },
        posts: [
          {
            id: 1,
            postUrl: 'https://www.naver.com',
          },
          {
            id: 2,
            postUrl: 'https://www.naver.com',
          },
        ],
      },
    },
  };
};

export const SuccessProfile = () => {
  return {
    example: {
      code: null,
      errorMessage: null,
      data: null,
    },
  };
};
