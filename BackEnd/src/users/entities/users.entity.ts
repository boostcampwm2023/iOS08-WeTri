import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  OneToOne,
  JoinColumn,
} from 'typeorm';
import { ProfileModel } from 'src/profiles/entities/profiles.entity';
import { IsString } from 'class-validator';
@Entity()
export class UserModel {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  @IsString({
    message: 'userId는 string 타입을 입력해야합니다.',
  })
  userId: string;

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
