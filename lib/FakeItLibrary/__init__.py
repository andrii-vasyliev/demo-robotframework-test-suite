"""
Library provides an interface for generating test data.
"""

from .fake_it import (
    Locales,
    DEFAULT_LOCALE,
    FAKE_IT,
    fake_customer_name,
    fake_customer_email,
    fake_domain_name,
    fake_string,
)

__all__ = [
    "Locales",
    "DEFAULT_LOCALE",
    "FAKE_IT",
    "fake_customer_name",
    "fake_customer_email",
    "fake_domain_name",
    "fake_string",
]

ROBOT_LIBRARY_SCOPE = "GLOBAL"
ROBOT_LIBRARY_VERSION = "1.0.0"
ROBOT_AUTO_KEYWORDS = False
