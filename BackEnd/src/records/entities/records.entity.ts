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
import { IsNumber, IsString } from 'class-validator';
@Entity()
export class RecordModel {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  @IsString()
  workout: string;

  @Column()
  @IsNumber()
  runningTime: number;

  @Column()
  @IsNumber()
  distance: number;

  @Column()
  @IsNumber()
  calorie: number;

  @Column({ nullable: true })
  @IsNumber()
  avgBpm: number;

  @Column({ nullable: true })
  @IsNumber()
  minBpm: number;

  @Column({ nullable: true })
  @IsNumber()
  maxBpm: number;

  @CreateDateColumn()
  createdAt: Date;

  @Column({ default: false })
  isPosted: boolean;

  @ManyToOne(() => ProfileModel, (profile) => profile.records) //manyToOne이 항상 외래키를 갖고 있음
  profile: ProfileModel;

  @OneToOne(() => PostModel, (post) => post.record)
  post: PostModel;
}
