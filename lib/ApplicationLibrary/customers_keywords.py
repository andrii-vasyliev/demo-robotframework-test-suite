from robot.api.deco import keyword
from .utils.audited import AuditInfo
from .exec_context import ExecContext, get_exec_context
from .entity.customer import Customer


class CustomersKeywords:
    """Customers related custom keywords"""

    @staticmethod
    @keyword
    def define_customer(
        customer_id: str, name: str, email: str | None, scope: str = "TEST"
    ) -> Customer:
        """Creates customer entity"""
        customer: Customer = Customer(customer_id, name, email)

        exec_context: ExecContext | None = get_exec_context(scope)
        if exec_context:
            customer.created = AuditInfo(
                exec_context.audit_info.timestamp.start_date,
                exec_context.audit_info.timestamp.end_date,
                exec_context.audit_info.user,
            )
            exec_context.customers = customer

        return customer
