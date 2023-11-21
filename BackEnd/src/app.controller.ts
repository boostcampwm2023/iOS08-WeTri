import { Controller, Get, Res } from '@nestjs/common';
import { Response } from 'express';
import { join } from 'path';

@Controller()
export class AppController {
  @Get()
  indexHTML(@Res() response: Response): void {
    response.sendFile(join(__dirname, '..', 'public', 'index.html'));
  }
}
