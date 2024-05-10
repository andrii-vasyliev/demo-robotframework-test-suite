"""Suite execution context library"""

ROBOT_LIBRARY_SCOPE = "SUITE"
ROBOT_LIBRARY_VERSION = "1.0.0"
ROBOT_AUTO_KEYWORDS = False

from robot.api.deco import keyword
from ApplicationLibrary.utils.exec_context import ExecContext


@keyword
def define_suite_context() -> ExecContext:
    """Creates suite execution context object"""
    return ExecContext()


@keyword
def dispose_suite_context() -> None:
    """Disposes suite execution context object"""
    pass
