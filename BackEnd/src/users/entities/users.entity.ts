import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  OneToOne,
  JoinColumn,
} from 'typeorm';
import { ProfileModel } from 'src/profiles/entities/profiles.entity';
@Entity()
export class UserModel {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  userId: string;

  @Column()
  provider: string;

  @OneToOne(() => ProfileModel, (profile) => profile.user, {
    eager: true,
    cascade: true,
  })
  @JoinColumn()
  profile: ProfileModel;
}
