import { ApiProperty, PickType } from "@nestjs/swagger"

class SuccessResDto {
    @ApiProperty({ description: "에러가 없는 경우 null" })
    code: number
    
    @ApiProperty({ description: "에러가 없는 경우 null" })
    errorMessage: string
}

class Token {
    @ApiProperty({ example: "ewaf1313RWDFA...", description: "Access Token 입니다." })
    accessToken: string

    @ApiProperty({ example: "ewaf1313RWDFA...", description: "Refresh Token 입니다." })
    refreshToken: string
}

export class SignupResDto extends SuccessResDto {
    @ApiProperty({type: () => Token})
    data: Token
}

export class CreateAccessTokenResDto extends SuccessResDto {
    @ApiProperty({type: () => PickType(Token, ['accessToken'])})
    data: Pick<Token, 'accessToken'>
}

export class CreateRefreshTokenResDto extends SuccessResDto {
    @ApiProperty({type: () => PickType(Token, ['refreshToken'])})
    data: Pick<Token, 'refreshToken'>
}