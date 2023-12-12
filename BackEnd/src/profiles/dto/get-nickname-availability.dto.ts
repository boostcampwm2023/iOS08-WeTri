import { PickType } from "@nestjs/swagger";
import { Profile } from "../entities/profiles.entity";

export class GetNicknameAvailAbailityDto extends PickType(Profile, ['nickname']) {}