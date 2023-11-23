import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  OneToOne,
  JoinColumn,
} from 'typeorm';
import { ProfileModel } from '../../profiles/entities/profiles.entity';
import { IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
@Entity()
export class UserModel {
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty({ example: "testid132", description: 'user의 id를 뜻합니다. (apple이면 apple id)' })
  @Column()
  @IsString({
    message: 'userId는 string 타입을 입력해야합니다.',
  })
  userId: string;

  @ApiProperty({ example: "apple", description: "userId의 플랫폼입니다." })
  @Column()
  @IsString({
    message: 'provider는 string 타입을 입력해야합니다.',
  })
  provider: string;

  @OneToOne(() => ProfileModel, (profile) => profile.user, {
    eager: true,
    cascade: true,
  })
  @JoinColumn()
  profile: ProfileModel;
}
