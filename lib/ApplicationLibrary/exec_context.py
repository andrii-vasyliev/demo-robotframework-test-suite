"""
Execution context module.

GlobalContext encompasses fundamental application entities such as the Product Catalog,
which can be referenced and utilized in test cases.

ExecContext details the application entities defined within suites and test cases,
which are the focus of validation, including Customers, Orders, and more.
"""

from typing import Any
from enum import StrEnum
from robot.libraries.BuiltIn import BuiltIn
from ApplicationLibrary.entity import Customer, Item
from ApplicationLibrary.utils import AuditInfo


class ExecContextScope(StrEnum):
    """
    Enum for the execution context type.

    Values represent the variable availability scopes supported by the Robot Framework VAR syntax.

    Note:
    - LOCAL is excluded as it is the default value of the VAR syntax.
    - GLOBAL is reserved for the global context.
    """

    TEST = "TEST"
    SUITE = "SUITE"
    SUITES = "SUITES"


"""
GLOBAL_SCOPE represents the value of the global scope in the Robot Framework VAR syntax,
used within keywords related to the global context.
"""
GLOBAL_SCOPE = "GLOBAL"


class GlobalContext:
    """
    GlobalContext is a base class for managing a global context.
    Attributes:
        catalog (tuple): A tuple containing instances of Item.

    Methods:
        __init__(items: list[dict] | None = None):
            Initializes the GlobalContext with a list of items.

        get_item_by_id(id: int) -> Item | None:
            Retrieves an item from the catalog by its id.

        clear() -> None:
            Clears all items from the catalog.

        __repr__() -> str:
            Returns a string representation of the GlobalContext instance.
    """

    def __init__(self, items: list[dict] | None = None):
        self.catalog: tuple = tuple()

        for i in items if items else []:
            self.catalog += (Item(**i),)

    def get_item_by_id(self, id: int) -> Item | None:
        """Get Product Catalog item by id"""
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
    """
    ExecContext is a base class for managing an execution context.
    Attributes:
        _customers (list): A list of Customer objects.
        audit_info (AuditInfo): An AuditInfo object containing audit information.

    Properties:
        customers (list[Customer]): Gets the list of Customer objects.
        customer_ids (list[str]): Returns a list of customer ids.
        customer_rows (list[tuple[Any, ...]]): Returns a list of customer rows.

    Methods:
        __init__():
            Initializes the ExecContext with a list of customers and audit information.

        __repr__() -> str:
            Returns a string representation of the ExecContext instance.
    """

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
    Returns a GlobalContext object of the given type.
    If no context is found, returns None.
    """
    return BuiltIn().get_variable_value("${" + GLOBAL_SCOPE + "_CONTEXT}", None)


def get_exec_context(
    scope: ExecContextScope | None = ExecContextScope.TEST,
) -> ExecContext | None:
    """
    Returns an ExecContext object in the given scope.
    If no context is found, returns None.

    Parameters:
        - *``scope``*: The scope of the execution context to return. Defaults to "TEST"
    """
    return (
        BuiltIn().get_variable_value(
            "${" + ExecContextScope[scope.upper()] + "_CONTEXT}", None
        )
        if scope
        else None
    )
