import { ApiProperty } from '@nestjs/swagger';

export class SuccessResDto {
  @ApiProperty({
    example: null,
    description: '에러 코드 성공시 null',
    nullable: true,
  })
  code: number | null;

  @ApiProperty({
    example: null,
    description: '에러 코드 성공시 null',
    nullable: true,
  })
  errorMessage: string | null;
}
