import {ApiProperty} from "@nestjs/swagger";
import {SuccessResDto} from "../../common/dto/SuccessRes.dto";
import {IsNotEmpty, IsString} from "class-validator";

export class ImageRequestDto {
  @ApiProperty({
    type: 'array',
    items: {
      type: 'string',
      format: 'binary',
      description: 'File upload',
    },
    description: '이미지 파일, 10MB 이하 .png .jpg .jpeg 파일만 가능',
  })
  images: any[];
}

export class ImageResponse {
  @ApiProperty({
    description: '이미지 이름',
    example: '스크린샷 2023-04-09 오후 6.46.20.png',
  })
  @IsString()
  @IsNotEmpty()
  imageName: string;
  @ApiProperty({
    description: '저장된 이미지 URL',
    example: 'https://cdnAdress/uuid.png',
  })
  @IsString()
  @IsNotEmpty()
  imageUrl: string;

  constructor(imageName: string, imageUrl: string) {
    this.imageName = imageName;
    this.imageUrl = imageUrl;
  }
}

export class ImageResponseDto extends SuccessResDto{
  @ApiProperty({ type: () => [ImageResponse] })
  data: ImageResponse[];
}
