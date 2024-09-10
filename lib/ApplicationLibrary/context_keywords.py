from robot.api.deco import keyword
from ApplicationLibrary.exec_context import GlobalContext, ExecContext


class ContextKeywords:
    """Keywords for execution context management"""

    @staticmethod
    @keyword
    def define_global_context(items: list[dict]) -> GlobalContext:
        """Creates global context object"""
        return GlobalContext(items)

    @staticmethod
    @keyword
    def dispose_global_context() -> None:
        """Disposes global context object"""
        pass

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
