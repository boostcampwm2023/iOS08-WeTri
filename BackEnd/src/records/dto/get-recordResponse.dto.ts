import { ApiProperty } from "@nestjs/swagger";
import {CreateExerciseLogDto} from "./create-exerciseLog.dto";

export class RecordDataDto {
    @ApiProperty({ example: null, description: '에러 코드 성공시 null', nullable: true })
    code: number | null;

    @ApiProperty({ example: null, description: '에러 설명 성공시 null', nullable: true })
    errorMessage: string | null;

    @ApiProperty({ type: () => CreateExerciseLogDto, description: '응답 데이터' })
    data: CreateExerciseLogDto;
}