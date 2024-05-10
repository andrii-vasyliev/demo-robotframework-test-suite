from typing import LiteralString
from robot.api.deco import library, keyword
from .database import PgSQLDB


@library(scope="GLOBAL", version="1.0.0", auto_keywords=False)
class PostgreSQLLibrary:
    """
    Library provides an interface for accessing PostgreSQL database.
    """

    def __init__(self):
        self._db: PgSQLDB | None = None

    @keyword()
    def pgsql_connect(self, url: str):
        """
        Connect to PostgreSQL database.
        """
        if self._db is not None:
            raise Exception("PostgreSQL database is already initialized")

        self._db = PgSQLDB()
        self._db.connect(url)

    @keyword()
    def pgsql_close(self):
        """
        Disconnect from PostgreSQL database.
        """
        if self._db is None:
            raise Exception("PostgreSQL database is not initialized")

        self._db.disconnect()
        self._db = None

    @keyword()
    def pgsql_query(self, query: LiteralString, params: list | None = None, **kwargs):
        """
        Execute query on PostgreSQL database.
        """
        if self._db is None:
            raise Exception("PostgreSQL database is not initialized")

        result = self._db.query(query, params, **kwargs)
        return result

    @keyword()
    def pgsql_execute(
        self, command: LiteralString, params: list | None = None, **kwargs
    ):
        """
        Execute command on PostgreSQL database.
        """
        if self._db is None:
            raise Exception("PostgreSQL database is not initialized")

        self._db.execute(command, params, **kwargs)
