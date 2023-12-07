export class PaginateResponseDto {
    items: any[];
    metaData: {
      lastItemId: number | null;
      isLastCursor: boolean;
      count: number;
    };
  }