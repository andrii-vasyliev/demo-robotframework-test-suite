from datetime import datetime


class DateTimeRange:
    """
    Class to represent a range of dates.

    Attributes:
        start_date (datetime): The start date of the range.
        end_date (datetime): The end date of the range.

    Methods:
        is_empty() -> bool: Check if the range is empty.
        __eq__(other: object) -> bool: Check if the range is equal to another range or date.
        __ne__(other: object) -> bool: Check if the range is not equal to another range or date.
        __lt__(other: object) -> bool: Check if the range is less than another range or date.
        __le__(other: object) -> bool: Check if the range is less than or equal to another range or date.
        __gt__(other: object) -> bool: Check if the range is greater than another range or date.
        __ge__(other: object) -> bool: Check if the range is greater than or equal to another range or date.
        __contains__(other: object) -> bool: Check if the range contains another range or date.
        __repr__() -> str: Return the string representation of the range.
    """

    def __init__(
        self, start_date: datetime | None = None, end_date: datetime | None = None
    ) -> None:
        self._start: datetime | None = start_date
        self._end: datetime | None = end_date

    @property
    def is_empty(self) -> bool:
        """Check if the range is empty."""
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
        """Check if the range is equal to another range or date."""
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
                return other._start == self._start and other._end == self._end
            elif self._start:
                return other._start == self._start
            elif self._end:
                return self._end == other._end

        return NotImplemented

    def __ne__(self, other: object) -> bool:
        """Check if the range is not equal to another range or date."""
        return not self.__eq__(other)

    def __lt__(self, other: object) -> bool:
        """Check if the range is less than another range or date."""
        if other is None or self.is_empty:
            return False

        if isinstance(other, datetime):
            if self._start:
                return self._start < other
            elif self._end:
                return self._end < other

        if isinstance(other, DateTimeRange):
            if other.is_empty:
                return False

            if self._start:
                if other._start:
                    return self._start < other._start
                elif other._end:
                    return self._start < other._end
            elif self._end:
                if other._start:
                    return self._end < other._start
                elif other._end:
                    return self._end < other._end

        return NotImplemented

    def __le__(self, other: object) -> bool:
        """Check if the range is less than or equal to another range or date."""
        return self.__lt__(other) or self.__eq__(other)

    def __gt__(self, other: object) -> bool:
        """Check if the range is greater than another range or date."""
        if other is None or self.is_empty:
            return False

        if isinstance(other, datetime):
            if self._start:
                return self._start > other
            elif self._end:
                return self._end > other

        if isinstance(other, DateTimeRange):
            if other.is_empty:
                return False

            if self._start:
                if other._start:
                    return self._start > other._start
                elif other._end:
                    return self._start > other._end
            elif self._end:
                if other._end:
                    return self._end > other._end
                elif other._start:
                    return self._end > other._start
            elif self._end:
                return False

        return NotImplemented

    def __ge__(self, other: object) -> bool:
        """Check if the range is greater than or equal to another range or date."""
        return self.__gt__(other) or self.__eq__(other)

    def __contains__(self, other: object) -> bool:
        """Check if the range contains another range or date."""
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
                if other._start and other._end:
                    return other._start in self and other._end in self
                else:
                    return False
            elif self._start:
                if other._start:
                    return other._start in self
                else:
                    return False
            elif self._end:
                if other._end:
                    return other._end in self
                else:
                    return False

        return NotImplemented

    def __repr__(self) -> str:
        return f"DateTimeRange(start={self._start!r}, end={self._end!r})"
