import { Injectable } from '@nestjs/common';
import { FindManyOptions, QueryBuilder, Repository } from 'typeorm';
import { BasePaginationDto } from './dto/base-pagination.dto';
import { ORM_OPERATION } from './const/orm-operation.const';
import { BaseModel } from './type/base-model.type';
import { JoinType, QueryOptions } from './type/query-options.type';

@Injectable()
export class CommonService {
  async paginate<T extends BaseModel>(
    paginationDto: BasePaginationDto,
    repository: Repository<T>,
    queryOptions: QueryOptions,
    overrideFindOptions: FindManyOptions<T> = {},
  ) {
    const findManyOptions: FindManyOptions<T> = {
      ...overrideFindOptions,
    };
    this.composeFindManyOptions(paginationDto, findManyOptions);
    const queryBuilder = this.makeQueryBuilder<T>(
      repository,
      queryOptions,
      findManyOptions,
    );
    const results: Array<T> = await queryBuilder.getMany();
    const lastItemId: number =
      results.length > 0 ? results[results.length - 1].id : null;
    const isLastCursor: boolean =
      results.length === paginationDto.take ? false : true;
    return {
      items: results,
      metaData: {
        lastItemId,
        isLastCursor,
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

  makeQueryBuilder<T>(
    repository: Repository<T>,
    queryOptions: QueryOptions,
    findManyOptions: FindManyOptions<T> = {},
  ) {
    let queryBuilder = repository.createQueryBuilder(queryOptions.mainAlias);
    queryBuilder = queryBuilder.setFindOptions(findManyOptions);
    if (queryOptions.join) {
      queryOptions.join.forEach((value: JoinType) => {
        queryBuilder = queryBuilder.leftJoin(value.joinColumn, value.joinAlias);
      });
    }
    if (queryOptions.select) {
      queryBuilder = queryBuilder.select(queryOptions.select);
    }
    return queryBuilder;
  }
}
