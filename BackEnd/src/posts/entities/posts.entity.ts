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
import { RecordModel } from '../../records/entities/records.entity';
import { ProfileModel } from '../../profiles/entities/profiles.entity';

@Entity()
export class PostModel {
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

  @OneToOne(() => RecordModel)
  @JoinColumn()
  record: RecordModel;

  @ManyToOne(() => ProfileModel, (profile) => profile.posts)
  profile: ProfileModel;
}
