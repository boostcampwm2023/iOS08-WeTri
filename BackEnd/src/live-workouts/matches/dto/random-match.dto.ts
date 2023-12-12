import { IsBoolean, IsNotEmpty, IsNumber, IsString } from 'class-validator';
import { Profile } from '../../../profiles/entities/profiles.entity';
import { ApiProperty } from '@nestjs/swagger';
import { SuccessResDto } from '../../../common/dto/SuccessRes.dto';

export class RandomMatchDto {
  @IsNumber()
  @IsNotEmpty()
  @ApiProperty({ example: 1 })
  workoutId: number;

  @IsNumber()
  @IsNotEmpty()
  @ApiProperty({ example: 60 })
  waitingTime: number;
}

export class RandomMatch {
  @IsBoolean()
  @IsNotEmpty()
  @ApiProperty({ example: true })
  matched: boolean;

  @IsString()
  @ApiProperty({ example: 'uuid' })
  myPublicId?: string;

  @IsString()
  @ApiProperty({ example: 'yyyy-mm-dd hh:mm:ss' })
  liveWorkoutStartTime?: string;

  @IsString()
  @ApiProperty({ example: 'uuid' })
  roomId?: string;

  @ApiProperty({
    example: [
      {
        nickname: '닌자',
        publicId: 'aaa-bbb-ccc',
        profileImage: 'https://cdn.com/asdasd.png',
        birthdate: '1999-01-01',
        createdAt: '2021-01-01 00:00:00',
        updatedAt: '2021-01-01 00:00:00',
        gender: 'male'
      },
      {
        nickname: '닌자2',
        publicId: 'aaa-bbb-111',
        profileImage: 'https://cdn.com/asdasd.png',
        birthdate: '1999-01-01',
        createdAt: '2021-01-01 00:00:00',
        updatedAt: '2021-01-01 00:00:00',
        gender: 'male'
      },
    ],
  })
  peers?: Profile[];
}

export class RandomMatchResDto extends SuccessResDto {
  @ApiProperty({ type: () => RandomMatch })
  data: RandomMatch;
}

export const randomNoMatchingResDto = () => {
  return {
    example: {
      code: null,
      errorMessage: null,
      data: {
        matched: false,
      },
    },
  };
};
