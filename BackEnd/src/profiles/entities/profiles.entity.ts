import { IsDate, IsString } from 'class-validator';
import { PostModel } from '../../posts/entities/posts.entity';
import { RecordModel } from '../../records/entities/records.entity';
import { UserModel } from '../../users/entities/users.entity';
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Generated,
  OneToOne,
  OneToMany,
} from 'typeorm';

@Entity()
export class ProfileModel {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  @IsString({
    message: 'nickname은 string 타입으로 입력해야합니다.',
  })
  nickname: string;

  @Column({ nullable: false })
  @IsString({
    message: 'gender는 string 타입으로 입력해야합니다.',
  })
  gender: string;

  @Column({ nullable: false })
  @IsDate({
    message: 'birthdate date 타입으로 입력해야합니다.',
  })
  birthdate: Date;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @Column({ unique: true })
  @Generated('uuid')
  publicId: string; //바꿀 예정

  @OneToOne(() => UserModel, (user) => user.profile)
  user: UserModel;

  @OneToMany(() => RecordModel, (record) => record.profile)
  records: RecordModel[];

  @OneToMany(() => PostModel, (post) => post.profile)
  posts: PostModel[];
}
