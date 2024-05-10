from datetime import datetime
from .datetime_range import DateTimeRange


class Periodic:

    def __init__(
        self,
        start_date: datetime | None = None,
        end_date: datetime | None = None,
    ) -> None:
        self._dt_range: DateTimeRange = DateTimeRange(start_date, end_date)

    @property
    def start_date(self) -> datetime | None:
        return self._dt_range.start

    @start_date.setter
    def start_date(self, value: datetime | None) -> None:
        self._dt_range.start = value

    @property
    def end_date(self) -> datetime | None:
        return self._dt_range.end

    @end_date.setter
    def end_date(self, value: datetime | None) -> None:
        self._dt_range.end = value

    @property
    def range(self) -> DateTimeRange:
        return self._dt_range

    def __repr__(self) -> str:
        return f"Periodic(range={self._dt_range})"
