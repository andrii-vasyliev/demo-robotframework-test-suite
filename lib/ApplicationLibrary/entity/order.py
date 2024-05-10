"""Order entity definition"""

from datetime import datetime
from ApplicationLibrary.utils.audited import Audited
from .order_item import OrderItem


class Order(Audited):
    """Order entity"""

    def __init__(self, order_id: str | None, order_items: list[OrderItem]):
        super().__init__()
        self.id: str | None = order_id
        self._status: str = "New"
        self.items: list[OrderItem] = order_items
        self._created: datetime | None = None

    @property
    def status(self) -> str:
        """Get order status"""
        return self._status.lower()

    @property
    def create_date(self) -> datetime | None:
        """Get order created datetime"""
        return self._created if self._created else None

    @create_date.setter
    def create_date(self, value: datetime) -> None:
        self._created = value

    def json(self) -> dict:
        """Convert order to dict"""
        return {
            "id": self.id,
            "status": self.status,
            "created": self.create_date,
            "order_items": [i.json() for i in self.items],
        }

    def __repr__(self) -> str:
        return f"Order(id={self.id}, status={self.status}, created={self.created}, items={self.items})"
