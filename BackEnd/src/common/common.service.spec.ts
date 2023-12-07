import { Test, TestingModule } from "@nestjs/testing";
import { CommonService } from "./common.service"

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

    describe('composeFindManyOptions', () => {
        
    })
})