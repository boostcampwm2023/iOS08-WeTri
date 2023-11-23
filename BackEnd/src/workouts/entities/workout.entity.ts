import {ApiProperty} from "@nestjs/swagger";
import {Column, OneToMany, PrimaryGeneratedColumn} from "typeorm";
import {RecordModel} from "../../records/entities/records.entity";
import {IsNumber, IsString} from "class-validator";

export class WorkoutModel {
    @ApiProperty({
        example: 1,
        description: '운동 종류 ID',
    })
    @PrimaryGeneratedColumn()
    @OneToMany(() => RecordModel, (record) => record.workout)
    @IsNumber()
    id: number;

    @ApiProperty({
        example: '달리기',
        description: '운동 종류 이름',
    })
    @Column()
    @IsString()
    name: string;
}
