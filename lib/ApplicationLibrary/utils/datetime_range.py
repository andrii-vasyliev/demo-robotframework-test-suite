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
        self.start_date: datetime | None = start_date
        self.end_date: datetime | None = end_date

    @property
    def is_empty(self) -> bool:
        """Check if the range is empty."""
        return not (self.start_date or self.end_date)

    def __eq__(self, other: object) -> bool:
        """Check if the range is equal to another range or date."""
        if other is None or self.is_empty:
            return False

        if isinstance(other, datetime):
            if self.start_date and self.end_date:
                return self.start_date <= other <= self.end_date
            elif self.start_date:
                return self.start_date <= other
            elif self.end_date:
                return self.end_date >= other
            else:
                return False

        if isinstance(other, DateTimeRange):
            if other.is_empty:
                return False

            if self.start_date and self.end_date:
                return (
                    other.start_date == self.start_date
                    and other.end_date == self.end_date
                )
            elif self.start_date:
                return other.start_date == self.start_date
            elif self.end_date:
                return self.end_date == other.end_date

        return NotImplemented

    def __ne__(self, other: object) -> bool:
        """Check if the range is not equal to another range or date."""
        return not self.__eq__(other)

    def __lt__(self, other: object) -> bool:
        """Check if the range is less than another range or date."""
        if other is None or self.is_empty:
            return False

        if isinstance(other, datetime):
            if self.start_date:
                return self.start_date < other
            elif self.end_date:
                return self.end_date < other

        if isinstance(other, DateTimeRange):
            if other.is_empty:
                return False

            if self.start_date:
                if other.start_date:
                    return self.start_date < other.start_date
                elif other.end_date:
                    return self.start_date < other.end_date
            elif self.end_date:
                if other.start_date:
                    return self.end_date < other.start_date
                elif other.end_date:
                    return self.end_date < other.end_date

        return NotImplemented

    def __le__(self, other: object) -> bool:
        """Check if the range is less than or equal to another range or date."""
        return self.__lt__(other) or self.__eq__(other)

    def __gt__(self, other: object) -> bool:
        """Check if the range is greater than another range or date."""
        if other is None or self.is_empty:
            return False

        if isinstance(other, datetime):
            if self.start_date:
                return self.start_date > other
            elif self.end_date:
                return self.end_date > other

        if isinstance(other, DateTimeRange):
            if other.is_empty:
                return False

            if self.start_date:
                if other.start_date:
                    return self.start_date > other.start_date
                elif other.end_date:
                    return self.start_date > other.end_date
            elif self.end_date:
                if other.end_date:
                    return self.end_date > other.end_date
                elif other.start_date:
                    return self.end_date > other.start_date
            elif self.end_date:
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
            if self.start_date and self.end_date:
                return self.start_date <= other <= self.end_date
            elif self.start_date:
                return self.start_date <= other
            elif self.end_date:
                return self.end_date >= other
            else:
                return False

        if isinstance(other, DateTimeRange):
            if other.is_empty:
                return False

            if self.start_date and self.end_date:
                if other.start_date and other.end_date:
                    return other.start_date in self and other.end_date in self
                else:
                    return False
            elif self.start_date:
                if other.start_date:
                    return other.start_date in self
                else:
                    return False
            elif self.end_date:
                if other.end_date:
                    return other.end_date in self
                else:
                    return False

        return NotImplemented

    def __repr__(self) -> str:
        return f"DateTimeRange(start={self.start_date!r}, end={self.end_date!r})"
