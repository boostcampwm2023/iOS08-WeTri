import { PickType } from '@nestjs/swagger';
import { User } from '../../users/entities/users.entity';

export class GetuserByUserIdAndProViderDto extends PickType(User, [
  'userId',
  'provider',
]) {}
