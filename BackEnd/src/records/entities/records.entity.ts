import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  OneToOne,
  JoinColumn,
} from 'typeorm';
import { Post } from '../../posts/entities/posts.entity';
import { Profile } from '../../profiles/entities/profiles.entity';
import { IsNumber, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Workout } from '../../workouts/entities/workout.entity';

@Entity()
export class Record {
  @PrimaryGeneratedColumn()
  @ApiProperty({
    example: 1,
    description: 'Record id',
  })
  id: number;

  @ApiProperty({
    example: '6000000',
    description: '운동을 한 시간 (초로 환산)',
  })
  @Column({ nullable: true })
  @IsNumber()
  workoutTime: number;

  @ApiProperty({
    example: '100000',
    description: '운동을 한 거리 (미터로 환산)',
  })
  @Column({ nullable: true })
  @IsNumber()
  distance: number;

  @ApiProperty({
    example: '360',
    description: '운동에 소모한 칼로리 (kcal 기준)',
  })
  @Column({ nullable: true })
  @IsNumber()
  calorie: number;

  @ApiProperty({
    example: '60',
    description: '운동 중 평균 심박수 (평균 기준)',
  })
  @Column({ nullable: true })
  @IsNumber()
  avgHeartRate: number;

  @ApiProperty({
    example: '120',
    description: '운동 중 최대 심박수 (최대 기준)',
  })
  @Column({ nullable: true })
  @IsNumber()
  minHeartRate: number;

  @ApiProperty({
    example: '180',
    description: '운동 중 최소 심박수 (최소 기준)',
  })
  @Column({ nullable: true })
  @IsNumber()
  maxHeartRate: number;

  @ApiProperty({
    example: 'YYYY-MM-DD hh:mm:ss',
    description: '운동 기록 생성 날짜',
  })
  @CreateDateColumn()
  createdAt: Date;

  @ApiProperty({
    example: 'https://www.naver.com',
    description: 'map capture을 의미합니다.',
  })
  @IsString()
  @Column()
  mapCapture: string;

  @ApiProperty({
    example: '1420/1234, 532/214, .....',
    description: '운동 기록 생성 날짜',
  })
  @IsString()
  @Column()
  gps: string;

  @Column({ default: false })
  isPosted: boolean;

  @ManyToOne(() => Profile, (profile) => profile.records) //manyToOne이 항상 외래키를 갖고 있음
  profile: Profile;

  @OneToOne(() => Post, (post) => post.record)
  post: Post;

  @ApiProperty({ example: '달리기', description: '선택한 운동 종료' })
  @ManyToOne(() => Workout, (workout) => workout.records)
  @JoinColumn()
  workout: Workout;
}
