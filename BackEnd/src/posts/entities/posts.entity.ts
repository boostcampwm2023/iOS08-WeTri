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

@Entity()
export class Post {
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

  @Column()
  postUrl: string;

  @OneToOne(() => Record)
  @JoinColumn()
  record: Record;

  @ManyToOne(() => Profile, (profile) => profile.posts)
  profile: Profile;
}
