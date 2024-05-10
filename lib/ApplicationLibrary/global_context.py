from robot.api.deco import keyword
from .entity.item import Item


class GlobalContext:
    """Global data class"""

    def __init__(self, items: list[dict] | None):
        self.catalog: tuple = tuple()

        for i in items if items else []:
            self.catalog += (Item(**i),)

    def get_item_by_id(self, id: int) -> Item | None:
        """Get item by id"""
        for item in self.catalog:
            if item.id == id:
                return item
        return None

    def clear(self) -> None:
        """Clear the global data"""
        self.catalog = tuple()

    def __repr__(self) -> str:
        return f"GlobalContext(catalog={self.catalog})"


gc: GlobalContext | None = None


class GlobalContextKeywords:
    @staticmethod
    @keyword
    def define_global_context(items: list[dict]) -> GlobalContext:
        """Creates global context object"""
        global gc
        gc = GlobalContext(items)
        return gc

    @staticmethod
    @keyword
    def dispose_global_context() -> None:
        """Disposes global context object"""
        global gc
        gc = None
