from datetime import datetime
from .datetime_range import DateTimeRange


class AuditInfo:
    """Base class for operation audit information"""

    def __init__(
        self,
        event_start: datetime | None = None,
        event_end: datetime | None = None,
        user: str | None = None,
    ) -> None:
        self.timestamp: DateTimeRange = DateTimeRange(event_start, event_end)
        self.user: str | None = user

    def __repr__(self) -> str:
        return f"AuditInfo(timestamp={self.timestamp}, user={self.user})"


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
        self._created.timestamp = DateTimeRange(
            value.timestamp.start_date, value.timestamp.end_date
        )
        self._created.user = value.user

    @property
    def updated(self) -> AuditInfo:
        return self._updated

    @updated.setter
    def updated(self, value: AuditInfo) -> None:
        self._updated.timestamp = DateTimeRange(
            value.timestamp.start_date, value.timestamp.end_date
        )
        self._updated.user = value.user
