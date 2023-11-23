import {ApiProperty} from "@nestjs/swagger";
import {Column, Entity, OneToMany, PrimaryGeneratedColumn} from "typeorm";
import {Record} from "../../records/entities/records.entity";
import {IsString} from "class-validator";

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
    name: string;

    @OneToMany(() => Record, (record) => record.workout)
    records: Record[];
}
