import {
  IsBoolean,
  IsDate,
  IsNotEmpty,
  IsNumber,
  IsString,
} from 'class-validator';
import { Profile } from '../../../profiles/entities/profiles.entity';
import { ApiOperation, ApiProperty } from '@nestjs/swagger';

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

export class RandomMatchResponseDto {
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
