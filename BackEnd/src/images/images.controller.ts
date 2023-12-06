import {
  Controller,
  Post,
  UploadedFiles,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import {ApiBody, ApiConsumes, ApiOperation, ApiResponse, ApiTags} from '@nestjs/swagger';
import { ImagesService } from './images.service';
import { AccessTokenGuard } from '../auth/guard/bearerToken.guard';
import { FilesInterceptor } from '@nestjs/platform-express';
import { MAX_IMAGE_SIZE } from './constant/images.constant';
import { ValidateFilesPipe } from './pipe/validate-files.pip';
import {ImageRequestDto, ImageResponseDto} from './dto/images.response';

@ApiTags('이미지 업로드 API')
@UseGuards(AccessTokenGuard)
@Controller('api/v1/images')
export class ImagesController {
  constructor(private readonly imagesService: ImagesService) {}

  @ApiOperation({summary: '이미지를 최대 5개까지 업로드 가능하다.'})
  @ApiResponse({ type: ImageResponseDto })
  @Post()
  @UseInterceptors(FilesInterceptor('images', 5))
  @ApiConsumes('multipart/form-data')
  @ApiBody({type: ImageRequestDto })
  async uploadImage(
    @UploadedFiles(
      new ValidateFilesPipe({
        maxSize: MAX_IMAGE_SIZE,
        fileType: ['image/png', 'image/jpeg', 'image/jpg'],
      }),
    )
    images: Express.Multer.File[],
  ) {
    return await this.imagesService.uploadImage(images);
  }
}
