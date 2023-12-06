import { Injectable, BadRequestException, PipeTransform } from '@nestjs/common';
import { FileUploadOptions } from '../interface/images.interface';
import {FileSizeTooLargeException, InvalidFileTypeException} from "../exceptions/images.exception";

@Injectable()
export class ValidateFilesPipe implements PipeTransform {
  constructor(private options: FileUploadOptions) {}

  transform(files: Express.Multer.File[]): Express.Multer.File[] {
    files.forEach((file) => {
      this.validateFileSize(file);
      this.validateFileType(file);
    });

    return files;
  }

  private validateFileSize(file: Express.Multer.File): void {
    const maxSize = this.options.maxSize;
    if (file.size > maxSize) {
      throw new FileSizeTooLargeException();
    }
  }

  private validateFileType(file: Express.Multer.File): void {
    const allowedTypes = this.options.fileType;
    if (!allowedTypes.includes(file.mimetype)) {
      throw new InvalidFileTypeException();
    }
  }
}
