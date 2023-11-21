import { Test, TestingModule } from '@nestjs/testing';
import { AppController } from './app.controller';
import { Response } from 'express';

describe('AppController', () => {
  let appController: AppController;
  let mockResponse: Response;

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [AppController],
    }).compile();

    appController = app.get<AppController>(AppController);
    mockResponse = {
      sendFile: jest.fn(),
    } as unknown as Response;
  });

  describe('indexHTML', () => {
    it('should call sendFile', () => {
      appController.indexHTML(mockResponse);
      expect(mockResponse.sendFile).toHaveBeenCalled();
    });
  });
});

