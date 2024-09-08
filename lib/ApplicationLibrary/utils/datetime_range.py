from datetime import datetime


class DateTimeRange:
    def __init__(
        self, start_date: datetime | None = None, end_date: datetime | None = None
    ):
        self._start: datetime | None = start_date
        self._end: datetime | None = end_date

    @property
    def is_empty(self) -> bool:
        return not (self._start or self._end)

    @property
    def start_date(self) -> datetime | None:
        return self._start

    @start_date.setter
    def start_date(self, value: datetime | None) -> None:
        self._start = value

    @property
    def end_date(self) -> datetime | None:
        return self._end

    @end_date.setter
    def end_date(self, value: datetime | None) -> None:
        self._end = value

    def __eq__(self, other: object) -> bool:
        if other is None or self.is_empty:
            return False

        if isinstance(other, datetime):
            if self._start and self._end:
                return self._start <= other <= self._end
            elif self._start:
                return self._start <= other
            elif self._end:
                return self._end >= other
            else:
                return False

        if isinstance(other, DateTimeRange):
            if other.is_empty:
                return False

            if self._start and self._end:
                if not (other._start and other._end):
                    return False
                return other._start == self._start and other._end == self._end
            elif self._start:
                if other._start is None:
                    return False
                elif other._end is None:
                    return other._start == self._start
                else:
                    return False
            elif self._end:
                if other._start is None:
                    return self._end == other._end
                elif other._end is None:
                    return False
                else:
                    return False

        return NotImplemented

    def __ne__(self, other: object) -> bool:
        return not self.__eq__(other)

    def __lt__(self, other: object) -> bool:
        if other is None or self.is_empty:
            return False

        # TODO: to implement when will be required

        return NotImplemented

    def __le__(self, other: object) -> bool:
        return self.__lt__(other) or self.__eq__(other)

    def __gt__(self, other: object) -> bool:
        if other is None or self.is_empty:
            return False

        # TODO: to implement when will be required

        return NotImplemented

    def __ge__(self, other: object) -> bool:
        return self.__gt__(other) or self.__eq__(other)

    def __contains__(self, other: object) -> bool:
        if other is None or self.is_empty:
            return False

        if isinstance(other, datetime):
            if self._start and self._end:
                return self._start <= other <= self._end
            elif self._start:
                return self._start <= other
            elif self._end:
                return self._end >= other
            else:
                return False

        if isinstance(other, DateTimeRange):
            if other.is_empty:
                return False

            if self._start and self._end:
                if not (other._start and other._end):
                    return False
                return other._start in self and other._end in self
            elif self._start:
                if other._start is None:
                    return False
                elif other._end is None:
                    return other._start in self
                else:
                    return other._start in self and other._end in self
            elif self._end:
                if other._start is None:
                    return other._end in self
                elif other._end is None:
                    return False
                else:
                    return other._start in self and other._end in self

        return NotImplemented

    def __repr__(self) -> str:
        return f"DateTimeRange(start={self._start!r}, end={self._end!r})"
