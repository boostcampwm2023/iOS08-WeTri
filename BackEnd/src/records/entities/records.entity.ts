import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  OneToOne,
} from 'typeorm';

import { PostModel } from '../../posts/entities/posts.entity';
import { ProfileModel } from '../../profiles/entities/profiles.entity';
@Entity()
export class RecordModel {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  exercise: string;

  @Column()
  runningTime: number;

  @Column()
  distance: number;

  @Column({ nullable: true })
  avgBpm: number;

  @Column({ nullable: true })
  minBpm: number;

  @Column({ nullable: true })
  maxBpm: number;

  @CreateDateColumn()
  createdAt: Date;

  @Column()
  checker: boolean;

  @ManyToOne(() => ProfileModel, (profile) => profile.records) //manyToOne이 항상 외래키를 갖고 있음
  profile: ProfileModel;

  @OneToOne(() => PostModel, (post) => post.record)
  post: PostModel;
}
