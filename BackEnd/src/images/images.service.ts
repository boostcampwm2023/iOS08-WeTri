import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { v4 as uuidv4 } from 'uuid';
import axios from 'axios';
import { ADULT_RATIO, PORN_RATIO } from './constant/images.constant';

@Injectable()
export class ImagesService {
  private readonly s3Client = new S3Client({
    endpoint: this.configService.getOrThrow('NCP_ENDPOINT'),
    region: this.configService.getOrThrow('NCP_REGION'),
    credentials: {
      accessKeyId: this.configService.getOrThrow('NCP_ACCESS_KEY'),
      secretAccessKey: this.configService.getOrThrow('NCP_SECRET_KEY'),
    },
  });
  constructor(private readonly configService: ConfigService) {}

  async uploadImage(images: Express.Multer.File[]) {
    const imageURL = [];
    for (const image of images) {
      const imageBuffer = image.buffer;
      const imageExtension = this.getExtension(image.originalname);
      const imageId = `${uuidv4()}.${imageExtension}`;
      const result = await this.isGreenEye(
        imageBuffer,
        imageId,
        image.originalname,
      );

      if (!result) {
        return;
      }

      await this.s3Client.send(
        new PutObjectCommand({
          Bucket: this.configService.getOrThrow('NCP_BUCKET_NAME'),
          Key: imageId,
          Body: imageBuffer,
          ContentType: image.mimetype,
        }),
      );

      imageURL.push({
        imageName: image.originalname,
        imageUrl: this.configService.getOrThrow('NCP_CDN_URL') + imageId,
      });
    }
    return imageURL;
  }

  private getExtension(imageName: string) {
    return imageName.split('.').pop();
  }
  private async isGreenEye(
    imageBuffer: Buffer,
    imageId: string,
    originalName: string,
  ) {
    const greenEyeURL = this.configService.getOrThrow('NCP_GREEN_EYE_URL');
    try {
      const headers = {
        'X-GREEN-EYE-SECRET': this.configService.getOrThrow(
          'NCP_GREEN_EYE_SECRET_KEY',
        ),
        'Content-Type': 'application/json',
      };
      const body = {
        version: 'V1',
        requestId: imageId,
        timestamp: Math.random(),
        images: [
          {
            name: originalName,
            data: imageBuffer.toString('base64'),
          },
        ],
      };
      const response = await axios.post(greenEyeURL, body, { headers });
      const { adult, porn } = response.data.images[0].result;

      if (!response.data || adult >= ADULT_RATIO || porn >= PORN_RATIO) {
        return false;
      }
    } catch (error) {
      Logger.log(error);
      return false;
    }
    return true;
  }
}
