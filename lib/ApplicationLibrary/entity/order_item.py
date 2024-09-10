"""Order Item entity definition"""

from ApplicationLibrary.utils.audited import Audited
from ApplicationLibrary.entity.item import Item


class OrderItem(Audited):
    """Order Item entity"""

    def __init__(self, item: Item, quantity: int) -> None:
        super().__init__()
        self.id: str | None = None
        self.item: Item = item
        self.quantity: int = quantity

    @property
    def item_id(self) -> str | None:
        """
        Returns the item id of the order item.
        """
        return self.item.id

    @property
    def name(self) -> str | None:
        """
        Returns the item name of the order item.
        """
        return self.item.name

    @property
    def price(self) -> float | None:
        """
        Returns the item price of the order item.
        """
        return self.item.price

    def json(self) -> dict:
        """Convert order item to dict"""
        return {
            "id": self.id,
            "item_id": self.item_id,
            "name": self.name,
            "price": self.price,
            "quantity": self.quantity,
        }

    def __repr__(self) -> str:
        return f"OrderItem(id={self.id}, item={self.item}, quantity={self.quantity})"
