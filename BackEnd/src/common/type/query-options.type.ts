export interface JoinType {
    joinColumn: string,
    joinAlias: string,
}

export interface QueryOptions {
    mainAlias: string;
    join?: JoinType[];
    select?: string[];
}