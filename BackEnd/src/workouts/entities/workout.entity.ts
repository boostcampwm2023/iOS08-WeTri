import { ApiProperty } from '@nestjs/swagger';
import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { Record } from '../../records/entities/records.entity';
import { IsNotEmpty, IsString } from 'class-validator';

@Entity()
export class Workout {
  @ApiProperty({
    example: 1,
    description: '운동 종류 ID',
  })
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty({
    example: '달리기',
    description: '운동 종류 이름',
  })
  @Column()
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty({
    example: '운동 종류의 아이콘 경로 문자열',
    description: 'figure.outdoor.workout',
  })
  @Column()
  @IsString()
  @IsNotEmpty()
  icon: string;

  @OneToMany(() => Record, (record) => record.workout)
  records: Record[];
}
