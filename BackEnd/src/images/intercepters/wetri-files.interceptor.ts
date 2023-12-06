import {Injectable, ExecutionContext, CallHandler, Logger} from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { InvalidFileCountOrFieldNameException } from '../exceptions/images.exception';

@Injectable()
export class WetriFilesInterceptor extends FilesInterceptor('images', 5) {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      catchError((err) => {
        Logger.warn(err);
        throw new InvalidFileCountOrFieldNameException();
      }),
    );
  }
}
