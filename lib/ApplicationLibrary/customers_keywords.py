from robot.api.deco import keyword
from FakeItLibrary import (
    Locales,
    DEFAULT_LOCALE,
    FAKE_IT,
    fake_customer_name,
    fake_customer_email,
)
from ApplicationLibrary.exec_context import (
    ExecContextScope,
    ExecContext,
    get_exec_context,
)
from ApplicationLibrary.utils import AuditInfo
from ApplicationLibrary.entity import Customer

_CREATE_CUSTOMER_FAKER: dict = {
    "name": fake_customer_name,
    "email": fake_customer_email,
}


class CustomersKeywords:
    """Customers related keywords"""

    @staticmethod
    @keyword
    def define_customer(
        customer_id: str,
        body: dict,
        scope: ExecContextScope | None = ExecContextScope.TEST,
    ) -> Customer:
        """
        Creates customer entity

        Parameters:
            - *``customer_id``*: Customer UUID
            - *``body``*: body of the Create Customer request
            - *``scope``*: Execution context scope. Default: TEST

        Returns:
            - Customer entity
        """
        customer: Customer = Customer(customer_id, body.get("name"), body.get("email"))

        exec_context: ExecContext | None = get_exec_context(scope)
        if exec_context:
            customer.created = AuditInfo(
                exec_context.audit_info.timestamp.start_date,
                exec_context.audit_info.timestamp.end_date,
                exec_context.audit_info.user,
            )
            exec_context.customers = customer

        return customer

    @staticmethod
    @keyword
    def populate_create_customer_body(
        locale: Locales = DEFAULT_LOCALE, body: dict | None = None
    ) -> dict:
        """
        Populates customer body.
        If *``body``* is not provided, generates create customer body with random values.
        If the element is specified as *``FAKE_IT``* in the body, a random value will be generated.
        If the element is None or empty in the body, it will be removed.

        Parameters:
            - *``locale``*: locale to use for fake data generation
            - *``body``*: body of the Create Customer request

        Returns:
            - Create Customer body based on the input
        """
        if not body:
            body = {"name": FAKE_IT, "email": FAKE_IT}

        for key, value in body.items():
            if value == FAKE_IT:
                body[key] = _CREATE_CUSTOMER_FAKER[key](locale)
            elif not value:
                body.pop(key, None)

        return body
