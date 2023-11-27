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
  @ApiProperty({ example: 'yyyy-mm-dd hh:mm:ss' })
  liveWorkoutStartTime?: string;

  @IsString()
  @ApiProperty({ example: 'uuid' })
  matchId?: string;

  @ApiProperty({
    example: [
      {
        nickname: 'nickname',
        publicId: 'profileImage',
        etc: 'etc',
      },
      {
        nickname: 'nickname',
        publicId: 'profileImage',
        etc: 'etc',
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
