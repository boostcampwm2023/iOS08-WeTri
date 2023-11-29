import { IsString } from "class-validator";

export class CheckMatchingDto {
    @IsString()
    clientId: string;

    @IsString()
    roomId: string;
}