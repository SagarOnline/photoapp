import { Injectable } from '@nestjs/common';
import { PoolClient, QueryResultRow } from 'pg';
import { DatabaseService } from './database.service';

@Injectable()
export class AppRepository {
  constructor(private readonly database: DatabaseService) {}

  query<Row extends QueryResultRow = QueryResultRow>(text: string, values: readonly unknown[] = []) {
    return this.database.query<Row>(text, values);
  }

  transaction<T>(work: (client: PoolClient) => Promise<T>): Promise<T> {
    return this.database.transaction(work);
  }
}