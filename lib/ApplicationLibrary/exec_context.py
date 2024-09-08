from typing import Any
from enum import StrEnum, auto
from robot.libraries.BuiltIn import BuiltIn
from .entity.customer import Customer
from .entity.item import Item
from .utils.audited import AuditInfo


class ExecContextType(StrEnum):
    """Enum for the exec context type"""

    TEST = auto()
    SUITE = auto()


class GlobalContext:
    """Base class for the global context"""

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


class ExecContext:
    """Base class for the execution context"""

    def __init__(self) -> None:
        self._customers: list[Customer] | None = None
        self.audit_info: AuditInfo = AuditInfo()

    @property
    def customers(self) -> list[Customer]:
        """Gets the list of Customer objects"""
        return self._customers if self._customers else []

    @customers.setter
    def customers(self, customer) -> None:
        """Appends a Customer object to the list of Customer objects"""
        if self._customers:
            self._customers.append(customer)
        else:
            self._customers = [
                customer,
            ]

    @property
    def customer_ids(self) -> list[str]:
        """Returns a list of customer ids"""
        return [customer.id for customer in self.customers]

    @property
    def customer_rows(self) -> list[tuple[Any, ...]]:
        """Returns a list of customer rows"""
        return sorted([customer.row for customer in self.customers], key=lambda x: x[0])

    def __repr__(self) -> str:
        return f"ExecContext(customers={self.customers}, audit_info={self.audit_info})"


def get_global_context() -> GlobalContext | None:
    """
    Returns a GlobalContext object.
    """
    return BuiltIn().get_variable_value(r"${GLOBAL_CONTEXT}", None)


def get_exec_context(scope: str = "TEST") -> ExecContext | None:
    """
    Returns an ExecContext object in the given scope.
    Defaults to the TEST scope.
    Available scopes: TEST, SUITE
    """
    return BuiltIn().get_variable_value(
        "${" + ExecContextType[scope] + "_CONTEXT}", None
    )
