import { Injectable } from '@nestjs/common';
import { FindManyOptions, Repository } from 'typeorm';
import { BasePaginationDto } from './dto/base-pagination.dto';
import { ORM_OPERATION } from './const/orm-operation.const';
import { BaseModel } from './type/base-model.type';

@Injectable()
export class CommonService {
  async paginate<T extends BaseModel>(
    paginationDto: BasePaginationDto,
    repository: Repository<T>,
    overrideFindOptions: FindManyOptions<T> = {},
  ) {
    const findManyOptions: FindManyOptions<T> = {
      ...overrideFindOptions,
    };
    this.composeFindManyOptions(paginationDto, findManyOptions);
    const results: Array<T> = await repository.find(findManyOptions);
    const lastItem: T =
      results.length > 0 && results.length === paginationDto.take
        ? results[results.length - 1]
        : null;
    return {
      items: results,
      metaData: {
        lastItemId: !lastItem ? null : lastItem.id,
        count: results.length,
      },
    };
  }

  composeFindManyOptions<T>(
    paginationDto: BasePaginationDto,
    overrideFindOptions: FindManyOptions<T>,
  ) {
    for (const [key, value] of Object.entries(paginationDto)) {
      const splitKey = key.split('__');
      if (
        (splitKey.length === 2 || splitKey.length === 3) &&
        !overrideFindOptions[splitKey[0]]
      ) {
        overrideFindOptions[splitKey[0]] = {};
      }
      if (splitKey.length === 3) {
        const [option, field, operator] = splitKey;
        overrideFindOptions[option][field] = ORM_OPERATION[operator](value);
      } else if (splitKey.length === 2) {
        const [option, field] = splitKey;
        overrideFindOptions[option][field] = value;
      } else if (splitKey.length === 1) {
        overrideFindOptions[key] = value;
      }
    }
  }
}
