import { PostModel } from 'src/posts/entities/posts.entity';
import { RecordModel } from 'src/records/entities/records.entity';
import { UserModel } from 'src/users/entities/users.entity';
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Generated,
  OneToOne,
  OneToMany
} from 'typeorm';

@Entity()
export class ProfileModel {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  nickname: string;

  @Column({ nullable: false })
  gender: string;

  @Column({ nullable: false })
  birthdate: Date;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @Column({ unique: true })
  @Generated('uuid')
  publicId: string;

  @OneToOne(() => UserModel, (user) => user.profile)
  user: UserModel;

  @OneToMany(() => RecordModel, (record) => record.profile)
  records: RecordModel[];

  @OneToMany(() => PostModel, (post) => post.profile)
  posts: PostModel[];
}