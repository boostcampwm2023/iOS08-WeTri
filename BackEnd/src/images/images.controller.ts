import {Controller, Post, UseGuards} from "@nestjs/common";
import {ApiTags} from "@nestjs/swagger";
import {ImagesService} from "./images.service";
import {AccessTokenGuard} from "../auth/guard/bearerToken.guard";

@ApiTags('이미지 업로드 API')
@UseGuards(AccessTokenGuard)
@Controller('api/v1/images')
export class ImagesController {
    constructor(private readonly imagesService: ImagesService) {}

    @Post()
    async uploadImage(

    ) {
        return await this.imagesService.uploadImage();
    }

    @Post('multiple')
    async uploadMultipleImages(

    ) {
        return await this.imagesService.uploadMultipleImages();
    }
}