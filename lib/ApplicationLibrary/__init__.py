"""Application custom keywords library"""

from robot.api.deco import library
from .customers_keywords import CustomersKeywords
from .orders_keywords import OrdersKeywords
from .context_keywords import ContextKeywords
from .exec_context import ExecContextType


@library(scope="GLOBAL", version="1.0.0", auto_keywords=False)
class ApplicationLibrary(CustomersKeywords, OrdersKeywords, ContextKeywords):
    """Library provides custom classes and keywords to use in the custom test framework"""
