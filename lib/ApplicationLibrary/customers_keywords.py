from robot.api.deco import keyword
from .utils.exec_context import ExecContext, get_exec_context
from .entity.customer import Customer


class CustomersKeywords:
    @staticmethod
    @keyword
    def define_customer(
        customer_id: str, name: str, email: str | None, scope: str = "TEST"
    ) -> Customer:
        """Creates customer entity"""
        customer: Customer = Customer(customer_id, name, email)

        exec_context: ExecContext | None = get_exec_context(scope)
        if exec_context:
            customer.created = exec_context.audit_info
            exec_context.customers = customer

        return customer
