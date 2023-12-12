import {
  ExecutionContext,
  InternalServerErrorException,
  createParamDecorator,
} from '@nestjs/common';

export const ProfileDeco = createParamDecorator(
  (data, context: ExecutionContext) => {
    const req = context.switchToHttp().getRequest();

    const profile = req.profile;

    if (!profile) {
      throw new InternalServerErrorException(
        'AccessTokenGuard를 사용하지 않았습니다.',
      );
    }
    return profile;
  },
);
