"""
Library provides an interface for accessing databases.
"""

from .postgresql import (
    pgsql_connect,
    pgsql_close,
    pgsql_execute,
    pgsql_query,
)

__all__ = [
    "pgsql_connect",
    "pgsql_close",
    "pgsql_execute",
    "pgsql_query",
]

ROBOT_LIBRARY_SCOPE = "GLOBAL"
ROBOT_LIBRARY_VERSION = "1.0.0"
ROBOT_AUTO_KEYWORDS = False
