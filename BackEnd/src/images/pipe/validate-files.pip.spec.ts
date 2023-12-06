import { ValidateFilesPipe } from './validate-files.pip';
import { FileSizeTooLargeException, InvalidFileTypeException } from '../exceptions/images.exception';
import {MAX_IMAGE_SIZE} from "../constant/images.constant";

describe('ValidateFilesPipe', () => {
    const options = {
        maxSize: MAX_IMAGE_SIZE,
        fileType: ['image/png', 'image/jpeg'],
    };
    const pipe = new ValidateFilesPipe(options);

    const mockFile = (size: number, mimetype: string): Express.Multer.File => ({
        originalname: 'testfile',
        mimetype,
        size,
        buffer: Buffer.alloc(size),
    } as Express.Multer.File);

    it('파일 크기가 정상적이고, 타입이 정상이라면 에러를 던지지 않는다.', () => {
        const validFile = mockFile(MAX_IMAGE_SIZE / 2, 'image/png');
        const files = [validFile];

        expect(() => pipe.transform(files)).not.toThrow();
    });

    it('파일 크기만 크다면, 파일 크키가 크다는 오류를 던진다.', () => {
        const largeFile = mockFile(MAX_IMAGE_SIZE * 2, 'image/png');
        const files = [largeFile];

        expect(() => pipe.transform(files)).toThrow(FileSizeTooLargeException);
    });

    it('파일 타입이 다르다면, 파일 타입이 다르다는 오류를 발생시킨다.', () => {
        const invalidTypeFile = mockFile(MAX_IMAGE_SIZE / 2, 'application/pdf');
        const files = [invalidTypeFile];

        expect(() => pipe.transform(files)).toThrow(InvalidFileTypeException);
    });
    it('만약 둘 다라면, 파일 크기가 크다는 오류를 발생시킨다.', () => {
        const invalidTypeFile = mockFile(MAX_IMAGE_SIZE * 2, 'application/pdf');
        const files = [invalidTypeFile];

        expect(() => pipe.transform(files)).toThrow(FileSizeTooLargeException);
    });
});
