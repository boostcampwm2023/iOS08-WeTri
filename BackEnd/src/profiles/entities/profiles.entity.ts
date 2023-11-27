import { IsString } from 'class-validator';
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
import { Admin } from 'src/admin/entities/admin.entity';

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
  birthdate: Date;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @Column({ unique: true })
  @Generated('uuid')
  publicId: string;

  @OneToOne(() => User, (user) => user.profile)
  user: User;

  @OneToMany(() => Record, (record) => record.profile)
  records: Record[];

  @OneToMany(() => Post, (post) => post.profile)
  posts: Post[];

  @OneToOne(() => Admin, (admin) => admin.profile)
  admin: Admin;
}
