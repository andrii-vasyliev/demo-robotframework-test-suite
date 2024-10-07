"""Item entity definition"""

from ApplicationLibrary.utils import Audited


class Item(Audited):
    """Item entity"""

    def __init__(
        self,
        id: str | None = None,
        name: str | None = None,
        price: float | None = None,
    ) -> None:
        super().__init__()
        self.id: str | None = id
        self.name: str | None = name
        self.price: float | None = price

    def __repr__(self) -> str:
        return f"Item(id={self.id}, name={self.name}, price={self.price})"
