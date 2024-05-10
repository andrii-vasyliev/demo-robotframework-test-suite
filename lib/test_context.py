"""Test execution context library"""

ROBOT_LIBRARY_SCOPE = "TEST"
ROBOT_LIBRARY_VERSION = "1.0.0"
ROBOT_AUTO_KEYWORDS = False

from robot.api.deco import keyword
from ApplicationLibrary.utils.exec_context import ExecContext


@keyword
def define_test_context() -> ExecContext:
    """Creates test execution context object"""
    return ExecContext()


@keyword
def dispose_test_context() -> None:
    """Disposes test execution context object"""
    pass
