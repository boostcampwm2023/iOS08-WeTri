import { Test, TestingModule } from "@nestjs/testing";
import { CommonService } from "./common.service"
import { BaseEntity, QueryBuilder, SelectQueryBuilder } from "typeorm";

describe('commonService', () => {
    let service: CommonService;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                CommonService,
            ]
        }).compile();
        
        service = module.get<CommonService>(CommonService);
    })

    describe('paginate', () => {
        const mockQueryBuilder = {
            setFindOptions: jest.fn().mockReturnThis(),
            leftJoin: jest.fn().mockReturnThis(),
            select: jest.fn().mockReturnThis(),
            getMany: jest.fn().mockResolvedValue([]),
          } as any
        it('QueryBuilder가 잘못 설정되어 있다면 InternalServerErrorException 에러 ', async () => {
            jest.spyOn(service,'makeQueryBuilder').mockReturnValue(mockQueryBuilder)
        })
    })
})