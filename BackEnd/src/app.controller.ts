import { Controller, Get, Res } from '@nestjs/common';
import { Response } from 'express';
import { join } from 'path';
import {ApiProperty, ApiTags} from "@nestjs/swagger";

@ApiTags('메인 페이지')
@Controller()
export class AppController {
  @Get()
  indexHTML(@Res() response: Response): void {
    response.sendFile(join(__dirname, '..', 'public', 'index.html'));
  }
}
