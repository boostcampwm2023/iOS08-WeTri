import { BasePaginationDto } from "../dto/base-pagination.dto";

export const mockPaginationDto: BasePaginationDto = {
    order__createdAt: 'DESC',
    take: 5,
    where__id__less_then: 12
}