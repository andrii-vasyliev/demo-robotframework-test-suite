from datetime import datetime
from robot.api.deco import keyword
from .utils.exec_context import ExecContext, get_exec_context
from .context_keywords import gc
from .entity.item import Item
from .entity.order_item import OrderItem
from .entity.order import Order


class OrdersKeywords:
    """Orders related custom keywords"""

    @staticmethod
    @keyword
    def define_order(items: list[dict], scope: str = "TEST") -> Order:
        """Creates order entity"""
        order_items: list[OrderItem] = []

        for order_item in items:
            item: Item | None = (
                gc.get_item_by_id(order_item["item_id"]) if gc and gc.catalog else None
            )
            order_items.append(
                OrderItem(item if item else Item(), order_item["quantity"])
            )
        order: Order = Order(None, order_items)

        exec_context: ExecContext | None = get_exec_context(scope)
        if exec_context:
            order.created = exec_context.audit_info

        return order

    @staticmethod
    @keyword
    def populate_order_data_from_response(
        order: Order, response: dict, scope: str = "TEST"
    ) -> None:
        """
        Populates order data from response
        - order id
        - created date
        - order items ids
        """

        order.id = response["id"]

        create_date: datetime = datetime.fromisoformat(response["created"])
        if create_date in order.created:
            order.create_date = create_date

        for order_item in response["order_items"]:
            for item in order.items:
                if (
                    order_item["item_id"] == item.item_id
                    and order_item["quantity"] == item.quantity
                    and item.id is None
                ):
                    item.id = order_item["id"]
                    break
