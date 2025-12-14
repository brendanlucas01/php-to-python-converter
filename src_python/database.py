import os
import psycopg2
from psycopg2.extras import RealDictCursor
import logging

class Database:
    def __init__(self):
        self.host = os.getenv('DB_HOST', 'localhost')
        self.database = os.getenv('DB_DATABASE', 'slim_db')
        self.user = os.getenv('DB_USERNAME', 'slim')
        self.password = os.getenv('DB_PASSWORD', 'slim_pass')
        self.port = os.getenv('DB_PORT', 5432)
        self.conn = None

    def connect(self):
        try:
            self.conn = psycopg2.connect(
                host=self.host,
                database=self.database,
                user=self.user,
                password=self.password,
                port=self.port
            )
            self.conn.autocommit = True
        except Exception as e:
            logging.error(f"Error connecting to database: {e}")
            raise e

    def get_cursor(self):
        if not self.conn or self.conn.closed:
            self.connect()
        return self.conn.cursor(cursor_factory=RealDictCursor)

    def query(self, sql, params=None):
        cursor = self.get_cursor()
        try:
            cursor.execute(sql, params)
            if cursor.description:
                return cursor.fetchall()
            return None
        except Exception as e:
            logging.error(f"Error executing query: {sql}, error: {e}")
            raise e
        finally:
            cursor.close()

    def fetch_one(self, sql, params=None):
        cursor = self.get_cursor()
        try:
            cursor.execute(sql, params)
            return cursor.fetchone()
        except Exception as e:
            logging.error(f"Error fetching one: {sql}, error: {e}")
            raise e
        finally:
            cursor.close()

    def select(self, table, columns, condition, join=None):
        # Simplistic implementation of Medoo's select
        # condition is a dict of {column: value} for WHERE clause (AND only)
        # columns can be a list or '*'

        cols = "*"
        if isinstance(columns, list):
            cols = ", ".join(columns)
        elif isinstance(columns, str):
            cols = columns

        where_clause = []
        params = []
        if condition:
            for k, v in condition.items():
                if isinstance(v, list): # IN clause
                    placeholders = ','.join(['%s'] * len(v))
                    where_clause.append(f"{k} IN ({placeholders})")
                    params.extend(v)
                else:
                    where_clause.append(f"{k} = %s")
                    params.append(v)

        where_str = ""
        if where_clause:
            where_str = "WHERE " + " AND ".join(where_clause)

        sql = f"SELECT {cols} FROM {table} {where_str}"
        return self.query(sql, tuple(params))

    def get(self, table, columns, condition, join=None):
        # Simplistic implementation of Medoo's get (fetch one)
        res = self.select(table, columns, condition, join)
        return res[0] if res else None

    def count(self, table, condition, column='*', join=None):
        where_clause = []
        params = []
        if condition:
            for k, v in condition.items():
                where_clause.append(f"{k} = %s")
                params.append(v)

        where_str = ""
        if where_clause:
            where_str = "WHERE " + " AND ".join(where_clause)

        sql = f"SELECT COUNT({column}) as count FROM {table} {where_str}"
        res = self.fetch_one(sql, tuple(params))
        return res['count'] if res else 0
