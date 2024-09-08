import contextlib
from typing import List, Any, LiteralString, Tuple, Generator
from psycopg.cursor import Cursor
from psycopg_pool import ConnectionPool


class PgSQLDB:
    def __init__(self):
        self._pool: ConnectionPool | None = None

    def connect(self, uri) -> None:
        """
        Connects to PostgreSQL database.
        """
        if self._pool is not None:
            raise Exception("Database is already initialized")

        try:
            self._pool = ConnectionPool(uri)
        except Exception:
            raise Exception("Database connection failed")

    @contextlib.contextmanager
    def cursor(self, **kwargs) -> Generator[Cursor[Tuple[Any, ...]], Any, None]:
        """
        Creates cursor for PostgreSQL database.
        """
        if self._pool is None:
            raise Exception("Database is not initialized")

        with self._pool.connection() as connection:
            with connection.cursor(**kwargs) as cursor:
                try:
                    yield cursor
                except Exception:
                    connection.rollback()
                    raise
                else:
                    connection.commit()

    def query(
        self, query: LiteralString, params: list | None = None, **kwargs
    ) -> List[Tuple[Any, ...]]:
        """
        Executes query on PostgreSQL database.
        """
        with self.cursor(**kwargs) as cursor:
            result: List[Tuple[Any, ...]] = cursor.execute(query, params).fetchall()

        return result

    def execute(
        self, command: LiteralString, params: list | None = None, **kwargs
    ) -> None:
        """
        Executes command on PostgreSQL database.
        """
        with self.cursor(**kwargs) as cursor:
            cursor.execute(command, params)

    def disconnect(self) -> None:
        """
        Disconnects from PostgreSQL database.
        """
        if self._pool is None:
            raise Exception("Database is not initialized")

        self._pool.close()
        self._pool = None
