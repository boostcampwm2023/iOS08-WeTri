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

  @ApiProperty({
    example: 'WERSDFQWE_2312...',
    description: '작성자의 고유 ID를 의미합니다.',
  })
  @Column()
  publicId: string;

  @ApiProperty({
    example: '안녕하세요 누구 누구 입니다.',
    description: '게시글 내용을 의미합니다.',
  })
  @IsString()
  @Column()
  content: string;

  @ApiProperty({
    example: '5',
    description: '해당 게시글의 like 수를 의미합니다.'
  })
  @Column({ nullable: true })
  like: number;

  @ApiProperty({
    example: '2023-12-03T13:47:08.677Z',
    description: '생성된 날짜를 의미합니다.'
  })
  @CreateDateColumn()
  createdAt: Date;

  @ApiProperty({
    example: '2023-12-03T13:47:08.677Z',
    description: '업데이트된 날짜를 의미합니다.'
  })
  @UpdateDateColumn()
  updatedAt: Date;

  @ApiProperty({
    example: '5',
    description: '삭제된 날짜를 의미합니다.'
  })
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
