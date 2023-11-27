import { ApiProperty } from "@nestjs/swagger";
import { IsString } from "class-validator";
import { Profile } from "src/profiles/entities/profiles.entity";
import { Column, CreateDateColumn, DeleteDateColumn, Entity, JoinColumn, OneToOne, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";

@Entity()
export class Admin {
    @PrimaryGeneratedColumn()
    id: number;

    @ApiProperty({ example: 'Uqweszvc4fds1342...', description: 'AdminId 필드입니다.'})
    @IsString()
    @Column()
    adminId: string;

    @ApiProperty({ example: '2314wrUdsfa2ads...', description: 'AdminPw 필드입니다.'})
    @IsString()
    @Column()
    adminPw: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn()
    updatedAt: Date;

    @DeleteDateColumn()
    deletedAt: Date;

    @OneToOne(() => Profile, (profile) => profile.admin, {
        eager: true,
    })
    @JoinColumn()
    profile: Profile;
}