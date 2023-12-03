import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  OneToOne,
  JoinColumn,
} from 'typeorm';
import { Record } from '../../records/entities/records.entity';
import { Profile } from '../../profiles/entities/profiles.entity';
import { ApiProperty } from '@nestjs/swagger';

@Entity()
export class Post {
  @ApiProperty({ example: '1', description: '테이블 id를 의미합니다.' })
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  publicId: string;

  @Column()
  content: string;

  @Column({ nullable: true })
  like: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @Column()
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
