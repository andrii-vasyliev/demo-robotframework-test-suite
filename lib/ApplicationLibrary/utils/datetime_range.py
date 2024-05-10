from datetime import datetime


class DateTimeRange:
    def __init__(self, start: datetime | None = None, end: datetime | None = None):
        self.start: datetime | None = start
        self.end: datetime | None = end

    @property
    def is_empty(self) -> bool:
        return not (self.start or self.end)

    def __eq__(self, other: object) -> bool:
        if other is None or self.is_empty:
            return False

        if isinstance(other, datetime):
            if self.start and self.end:
                return self.start <= other <= self.end
            elif self.start:
                return self.start <= other
            elif self.end:
                return self.end >= other
            else:
                return False

        if isinstance(other, DateTimeRange):
            if other.is_empty:
                return False

            if self.start and self.end:
                if not (other.start and other.end):
                    return False
                return other.start == self.start and other.end == self.end
            elif self.start:
                if other.start is None:
                    return False
                elif other.end is None:
                    return other.start == self.start
                else:
                    return False
            elif self.end:
                if other.start is None:
                    return self.end == other.end
                elif other.end is None:
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
            if self.start and self.end:
                return self.start <= other <= self.end
            elif self.start:
                return self.start <= other
            elif self.end:
                return self.end >= other
            else:
                return False

        if isinstance(other, DateTimeRange):
            if other.is_empty:
                return False

            if self.start and self.end:
                if not (other.start and other.end):
                    return False
                return other.start in self and other.end in self
            elif self.start:
                if other.start is None:
                    return False
                elif other.end is None:
                    return other.start in self
                else:
                    return other.start in self and other.end in self
            elif self.end:
                if other.start is None:
                    return other.end in self
                elif other.end is None:
                    return False
                else:
                    return other.start in self and other.end in self

        return NotImplemented

    def __repr__(self) -> str:
        return f"DateTimeRange(start={self.start!r}, end={self.end!r})"
