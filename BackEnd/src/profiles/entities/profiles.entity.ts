import { IsString, IsUrl } from 'class-validator';
import { Post } from '../../posts/entities/posts.entity';
import { Record } from '../../records/entities/records.entity';
import { User } from '../../users/entities/users.entity';
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
import { ApiProperty } from '@nestjs/swagger';
import { Admin } from '../../admin/entities/admin.entity';

@Entity()
export class Profile {
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty({ example: '닉네임', description: '닉네임 필드를 의미합니다.' })
  @Column({ unique: true })
  @IsString({
    message: 'nickname은 string 타입으로 입력해야합니다.',
  })
  nickname: string;

  @ApiProperty({
    example: 'Male',
    description: '성별 필드를 의미합니다',
    enum: ['Male', 'Female', 'Other'],
  })
  @Column({ nullable: false })
  @IsString({
    message: 'gender는 string 타입으로 입력해야합니다.',
  })
  gender: string;

  @ApiProperty({
    example: '2023-11-06',
    description: '생년월일 필드를 의미합니다.',
  })
  @Column({ nullable: false })
  @IsString({
    message: 'birthdate string 타입으로 입력해야합니다.',
  })
  birthdate: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @ApiProperty({
    example: 'XCVSF-SADF123..',
    description: '유저의 고유 식별 ID를 의미합니다.',
  })
  @Column({ unique: true })
  @Generated('uuid')
  publicId: string;

  @ApiProperty({
    example: 'https://s3.bucket.url',
    description: '프로필 이미지 url을 의미합니다.',
  })
  @Column({ nullable: true })
  profileImage: string;

  @OneToOne(() => User, (user) => user.profile)
  user: User;

  @OneToMany(() => Record, (record) => record.profile)
  records: Record[];

  @OneToMany(() => Post, (post) => post.profile)
  posts: Post[];

  @OneToOne(() => Admin, (admin) => admin.profile)
  admin: Admin;
}
