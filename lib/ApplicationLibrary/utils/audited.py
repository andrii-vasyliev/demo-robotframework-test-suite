from datetime import datetime
from .periodic import Periodic


class AuditInfo(Periodic):
    """Base class for operation audit information"""

    def __init__(
        self,
        start: datetime | None = None,
        end: datetime | None = None,
        user: str | None = None,
    ) -> None:
        super().__init__(start, end)
        self.user: str | None = user

    def __contains__(self, other: object) -> bool:
        if not isinstance(other, datetime):
            return NotImplemented

        return other in self.range

    def __repr__(self) -> str:
        return f"AuditInfo(range={self.range}, user={self.user})"


class Audited:
    """Base class for objects that have audit information"""

    def __init__(self) -> None:
        self._created: AuditInfo = AuditInfo()
        self._updated: AuditInfo = AuditInfo()

    @property
    def created(self) -> AuditInfo:
        return self._created

    @created.setter
    def created(self, value: AuditInfo) -> None:
        self._created.start_date = value.start_date
        self._created.end_date = value.end_date
        self._created.user = value.user

    @property
    def updated(self) -> AuditInfo:
        return self._updated

    @updated.setter
    def updated(self, value: AuditInfo) -> None:
        self._updated.start_date = value.start_date
        self._updated.end_date = value.end_date
        self._updated.user = value.user
