import { ApiProperty } from "@nestjs/swagger";

class RecordData {
    @ApiProperty({ example: 1, description: '운동 기록 레코드 ID' })
    recordId: number;
}

export class CreateRecordDataDto {
    @ApiProperty({ example: null, description: '에러 코드 성공시 null', nullable: true })
    code: number | null;

    @ApiProperty({ example: null, description: '에러 설명 성공시 null', nullable: true })
    errorMessage: string | null;

    @ApiProperty({ type: () => RecordData, description: '응답 데이터' })
    data: RecordData;
}