jest.mock('axios');
jest.mock('@aws-sdk/client-s3', () => ({
  S3Client: jest.fn().mockImplementation(() => ({
    send: jest.fn(),
  })),
}));

import { Test, TestingModule } from '@nestjs/testing';
import { ImagesService } from './images.service';
import { ConfigService } from '@nestjs/config';
import { S3Client } from '@aws-sdk/client-s3';
import axios from 'axios';
import {
  NotAccessToGreenEyeException,
  NotAccessToNCPException,
} from './exceptions/images.exception';

describe('ImagesService', () => {
  let service: ImagesService;
  let configService: ConfigService;
  let s3Client: S3Client;

  let imageBuffer: Buffer;
  let imageId: string;
  let originalName: string;

  const config = {
    NCP_ENDPOINT: 'https://이미지사이트.com',
    NCP_REGION: '한국',
    NCP_ACCESS_KEY: '엑세스키',
    NCP_SECRET_KEY: '비밀키',
    NCP_BUCKET_NAME: '스토리지',
    NCP_CDN_URL: 'https://시디엔사이트.com/',
  };

  const mockMulterFile = (filename: string): Express.Multer.File =>
    ({
      fieldname: 'images',
      originalname: filename,
      mimetype: 'image/png',
      filename: filename,
      size: 1024,
      buffer: Buffer.from('abc'),
    }) as Express.Multer.File;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ImagesService,
        {
          provide: ConfigService,
          useValue: {
            getOrThrow: jest.fn((key: string) => {
              return config[key];
            }),
          },
        },
        S3Client,
      ],
    }).compile();

    service = module.get<ImagesService>(ImagesService);
    configService = module.get<ConfigService>(ConfigService);
    s3Client = module.get<S3Client>(S3Client);

    imageBuffer = Buffer.from('test');
    imageId = 'ababab';
    originalName = 'test.png';

    jest.clearAllMocks();
  });

  describe('uploadImage', () => {
    it('그린아이에서 오류가 발생할 때, 그린아이 오류를 보낸다.', async () => {
      (axios.post as jest.Mock).mockRejectedValue(
        new Error('그린아이에서 오류가 발생'),
      );

      await expect(
        service.uploadImage([mockMulterFile('test.png')]),
      ).rejects.toThrow(NotAccessToGreenEyeException);
    });
  });
  describe('오브젝트에 저장하는 테스트 ', () => {
    it('오브젝트 스토리지 저장이 오류가 발생하면 NCP에 접근할 수 없다는 오류를 던진다.', async () => {
      (s3Client.send as jest.Mock).mockRejectedValue(
        new Error('오브젝트 스토리지 저장 오류'),
      );
      await expect(
        service['sendToObjectStorage'](
          imageId,
          imageBuffer,
          mockMulterFile('test.png'),
        ),
      ).rejects.toThrow(NotAccessToNCPException);
    });
  });

  describe('getExtension 메서드 테스트', () => {
    it('파일명의 끝 부분만 잘라서 준다.', () => {
      const filename = 'test.png';
      const extension = service['getExtension'](filename);
      expect(extension).toBe('png');
    });
    it('만약 파일에 .이 많을 경우.', () => {
      const filename = 'asd.asd.asd.asd.test.png';
      const extension = service['getExtension'](filename);
      expect(extension).toBe('png');
    });
  });

  describe('isGreenEye 메서드 테스트', () => {
    it('그린 아이의 심의를 통과하면, true를 리턴한다.', async () => {
      (axios.post as jest.Mock).mockResolvedValue({
        data: {
          images: [{ result: { adult: 0, porn: 0 } }],
        },
      });
      const isGreen = await service['isGreenEye'](
        imageBuffer,
        imageId,
        originalName,
      );
      expect(isGreen).toBe(true);
    });

    it('그린 아이의 심의를 통과하지 못하면, false를 리턴한다.', async () => {
      (axios.post as jest.Mock).mockResolvedValue({
        data: {
          images: [{ result: { adult: 0.7, porn: 0.4 } }],
        },
      });
      const isGreen = await service['isGreenEye'](
        imageBuffer,
        imageId,
        originalName,
      );
      expect(isGreen).toBe(false);
    });

    it('그린아이에 엑세스 요청이 reject 된다면 그린아이 에러를 던진다.', async () => {
      (axios.post as jest.Mock).mockRejectedValue(
        new NotAccessToGreenEyeException(),
      );
      await expect(
        service['isGreenEye'](imageBuffer, imageId, originalName),
      ).rejects.toThrow(NotAccessToGreenEyeException);
    });
  });
});
