import { plainToClass } from 'class-transformer';
import { validate } from 'class-validator';
import {
  ImageRequestDto,
  ImageResponse,
  ImageResponseDto,
} from './images.response';

describe('ImageDto', () => {
  describe('ImageResponse', () => {
    it('만약 둘 중 하나라도 문자열이 비여있다면, 오류를 발생시킨다. 둘다면 2개 하나면 1개', async () => {
      const dto = plainToClass(ImageResponse, {
        imageName: '',
        imageUrl: '',
      });
      const errors = await validate(dto);
      expect(errors.length).toBeGreaterThan(0);
    });

    it('정상적으로 이미지 생성이 완료되었다면, 오류는 발생하지 않는다.', async () => {
      const dto = plainToClass(ImageResponse, {
        imageName: 'example.png',
        imageUrl: 'https://cdn.example.com/example.png',
      });
      const errors = await validate(dto);
      expect(errors.length).toBe(0);
    });
  });

  describe('ImageResponseDto', () => {
    it('이미지 Response는 imageName과 imageUrl을 가진 배열이다.', () => {
      const imageResponse = new ImageResponse(
        'test.png',
        'https://cdn.naver.com/test.png',
      );
      const dto = new ImageResponseDto();
      dto.data = [imageResponse];

      expect(dto.data).toBeInstanceOf(Array);
      expect(dto.data[0]).toBeInstanceOf(ImageResponse);
    });
  });
});
