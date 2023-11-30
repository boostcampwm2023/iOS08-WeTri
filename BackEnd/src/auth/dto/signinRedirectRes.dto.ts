import { ApiProperty } from "@nestjs/swagger";
import { IsString } from "class-validator";
import { SuccessResDto } from "src/common/dto/SuccessRes.dto";

class SigninRedirectRes {
    @ApiProperty({
        example: "api/v1/...",
        description: "Redirect url"
    })
    @IsString()
    redirectUrl: string

    @ApiProperty({
        example: "1233498sdafksdjhfk...",
        description: "userId -> 애플리케이션에서 고유한 apple id를 뜻함"
    })
    @IsString()
    userId: string

    @ApiProperty({
        example: "apple",
        description: "로그인 플랫폼"
    })
    @IsString()
    provider: string
}

export class SigninRedirectResDto extends SuccessResDto {
    @ApiProperty({ type: () => SigninRedirectRes })
    data: SigninRedirectRes;
}