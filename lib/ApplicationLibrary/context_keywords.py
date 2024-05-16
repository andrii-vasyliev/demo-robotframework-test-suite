from robot.api.deco import keyword
from .utils.exec_context import GlobalContext, ExecContext


gc: GlobalContext | None = None


class ContextKeywords:
    """Keywords for context management"""

    @staticmethod
    @keyword
    def define_global_context(items: list[dict]) -> GlobalContext:
        """Creates global context object"""
        global gc
        gc = GlobalContext(items)
        return gc

    @staticmethod
    @keyword
    def dispose_global_context() -> None:
        """Disposes global context object"""
        global gc
        gc = None

    @staticmethod
    @keyword
    def define_suite_context() -> ExecContext:
        """Creates suite execution context object"""
        return ExecContext()

    @staticmethod
    @keyword
    def dispose_suite_context() -> None:
        """Disposes suite execution context object"""
        pass

    @staticmethod
    @keyword
    def define_test_context() -> ExecContext:
        """Creates test execution context object"""
        return ExecContext()

    @staticmethod
    @keyword
    def dispose_test_context() -> None:
        """Disposes test execution context object"""
        pass
