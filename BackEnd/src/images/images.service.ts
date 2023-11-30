import {Injectable} from "@nestjs/common";
import {ConfigService} from "@nestjs/config";
import {PutObjectCommand, S3Client} from "@aws-sdk/client-s3";
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class ImagesService {
    private readonly s3Client = new S3Client({
        endpoint: this.configService.getOrThrow('NCP_ENDPOINT'),
        region: this.configService.getOrThrow('NCP_REGION'),
        credentials: {
            accessKeyId: this.configService.getOrThrow('NCP_ACCESS_KEY'),
            secretAccessKey: this.configService.getOrThrow('NCP_SECRET_KEY'),
        },
    })
    constructor(private readonly configService: ConfigService) {}

    async uploadImage(images: Express.Multer.File[]) {
        const imageURL = [];
        for (const image of images) {
            const imageBuffer = image.buffer;
            const imageExtension = this.getExtension(image.originalname);
            if (!this.isGreenEye(imageBuffer)) {

            }

            const imageId = `${uuidv4()}.${imageExtension}`;
            await this.s3Client.send(
                new PutObjectCommand({
                    Bucket: this.configService.getOrThrow('NCP_BUCKET_NAME'),
                    Key: imageId,
                    Body: imageBuffer,
                    ContentType: image.mimetype,
                })
            );

            imageURL.push({
                imageName: image.originalname,
                imageUrl: this.configService.getOrThrow('NCP_CDN_URL')
                + imageId
            });

        }
        return imageURL;
    }

    private getExtension(imageName: string) {
        return imageName.split('.').pop();
    }
    private isGreenEye(imageBuffer: Buffer) {
        return false;
    }
}