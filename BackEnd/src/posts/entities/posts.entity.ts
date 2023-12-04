import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  OneToOne,
  JoinColumn,
  DeleteDateColumn,
} from 'typeorm';
import { Record } from '../../records/entities/records.entity';
import { Profile } from '../../profiles/entities/profiles.entity';
import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

@Entity()
export class Post {
  @ApiProperty({ example: '1', description: '테이블 id를 의미합니다.' })
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  publicId: string;

  @ApiProperty({
    example: '안녕하세요 누구 누구 입니다.',
    description: '게시글 내용을 의미합니다.',
  })
  @IsString()
  @Column()
  content: string;

  @Column({ nullable: true })
  like: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @DeleteDateColumn()
  deletedAt: Date;

  @ApiProperty({
    example: 'https://www.naver.com',
    description: '게시물 url을 의미합니다.',
  })
  @Column()
  postUrl: string;

  @OneToOne(() => Record)
  @JoinColumn()
  record: Record;

  @ManyToOne(() => Profile, (profile) => profile.posts)
  profile: Profile;
}
