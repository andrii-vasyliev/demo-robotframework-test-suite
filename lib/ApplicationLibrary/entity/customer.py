"""Customer entity definition"""

from ApplicationLibrary.utils import Audited


class Customer(Audited):
    """Customer entity"""

    def __init__(self, customer_id: str, name: str, email: str | None) -> None:
        super().__init__()
        self.id: str = customer_id
        self.name = name
        self.email = email

    @property
    def name(self) -> str | None:
        """Gets customer name"""
        return self._name

    @name.setter
    def name(self, name: str) -> None:
        """Sets customer name"""
        if name and name.strip():
            self._name: str | None = name.strip()
        else:
            self._name = None

    @property
    def email(self) -> str | None:
        """Gets customer email"""
        return self._email

    @email.setter
    def email(self, email: str | None) -> None:
        """Sets customer email"""
        customer_email: str | None = email.strip() if email else email
        if customer_email:
            at_pos: int = customer_email.find("@")
            self._email: str | None = (
                customer_email[: at_pos + 1] + customer_email[at_pos + 1 :].lower()
            ).strip("<>")
        else:
            self._email = None

    @property
    def json(self) -> dict:
        """Converts customer to dictionary"""
        return {"email": self.email, "id": self.id, "name": self.name}

    @property
    def row(self) -> tuple:
        """Converts customer to tuple"""
        return (
            self.id,
            self.name,
            self.email,
            self.created.timestamp if not self.created.timestamp.is_empty else None,
            self.created.user,
            self.updated.timestamp if not self.updated.timestamp.is_empty else None,
            self.updated.user,
        )

    def __repr__(self) -> str:
        return f"Customer(id={self.id}, name={self.name}, email={self.email}, created={self.created}, updated={self.updated})"
