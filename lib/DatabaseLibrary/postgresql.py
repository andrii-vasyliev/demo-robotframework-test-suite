"""
PostgreSQL database library
"""

from contextlib import contextmanager
from typing import List, Any, LiteralString, Tuple, Generator
from psycopg.cursor import Cursor
from psycopg_pool import ConnectionPool
from robot.api.deco import keyword

__pool: ConnectionPool | None = None


@keyword()
def pgsql_connect(uri: str) -> None:
    """
    Connects to PostgreSQL database.

    Parameters:
        - *``uri``*: connection URI
    """
    global __pool
    if __pool is not None:
        raise Exception("PostgreSQL database is already initialized")

    try:
        __pool = ConnectionPool(uri)
    except Exception:
        raise Exception("PostgreSQL database connection failed")


@keyword()
def pgsql_close() -> None:
    """
    Disconnects from PostgreSQL database.
    """
    global __pool
    if __pool is None:
        raise Exception("PostgreSQL database is not initialized")

    __pool.close()
    __pool = None


@contextmanager
def get_cursor(**kwargs) -> Generator[Cursor[Tuple[Any]], Any, None]:
    """
    Gets cursor from the PostgreSQL connection pool.
    The cursor is automatically closed after the execution of the block.

    Parameters:
        - *``kwargs``*: keyword arguments passed to the cursor
    """
    if __pool is None:
        raise Exception("PostgreSQL database is not initialized")

    with __pool.connection() as connection:
        with connection.cursor(**kwargs) as cursor:
            try:
                yield cursor
            except Exception:
                connection.rollback()
                raise
            else:
                connection.commit()


@keyword()
def pgsql_query(
    query: LiteralString, params: list | None = None, **kwargs
) -> List[Tuple[Any, ...]]:
    """
    Executes *``query``* with *``params``* on PostgreSQL database and returns result.
    Each row is represented as a tuple of values.

    Parameters:
        - *``query``*: query to execute
        - *``params``*: query parameters
    """
    with get_cursor(**kwargs) as cursor:
        result: List[Tuple[Any, ...]] = cursor.execute(query, params).fetchall()

    return result


@keyword()
def pgsql_execute(command: LiteralString, params: list | None = None, **kwargs) -> None:
    """
    Executes *``command``* with *``params``* on PostgreSQL database.
    The command does not return any result.

    Parameters:
        - *``command``*: command to execute
        - *``params``*: command parameters
    """
    with get_cursor(**kwargs) as cursor:
        cursor.execute(command, params)
