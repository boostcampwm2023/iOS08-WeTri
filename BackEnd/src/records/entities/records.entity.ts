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
import {ApiProperty} from "@nestjs/swagger";
@Entity()
export class RecordModel {
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty({ example: 'biking', description: '선택한 운동 종료' })
  @Column()
  @IsString()
  workout: string;

  @ApiProperty({ example: '6000000', description: '운동을 한 시간 (초로 환산)' })
  @Column()
  @IsNumber()
  workoutTime: number;

  @ApiProperty( {example: '100000', description: '운동을 한 거리 (미터로 환산)'} )
  @Column()
  @IsNumber()
  distance: number;

  @ApiProperty( {example: '360', description: '운동에 소모한 칼로리 (kcal 기준)'} )
  @Column()
  @IsNumber()
  calorie: number;

  @ApiProperty({example: '60', description: '운동 중 평균 심박수 (평균 기준)'})
  @Column({ nullable: true })
  @IsNumber()
  avgHeartRate: number;

  @ApiProperty( {example: '120', description: '운동 중 최대 심박수 (최대 기준)'} )
  @Column({ nullable: true })
  @IsNumber()
  minHeartRate: number;

  @ApiProperty( {example: '180', description: '운동 중 최소 심박수 (최소 기준)'} )
  @Column({ nullable: true })
  @IsNumber()
  maxHeartRate: number;

  @CreateDateColumn()
  createdAt: Date;

  @Column({ default: false })
  isPosted: boolean;

  @ManyToOne(() => ProfileModel, (profile) => profile.records) //manyToOne이 항상 외래키를 갖고 있음
  profile: ProfileModel;

  @OneToOne(() => PostModel, (post) => post.record)
  post: PostModel;
}
