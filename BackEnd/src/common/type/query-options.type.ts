export interface JoinType {
  joinColumn: string;
  joinAlias: string;
}

export interface QueryOptions {
  mainAlias: string;
  joins?: JoinType[];
  selects?: string[];
}
