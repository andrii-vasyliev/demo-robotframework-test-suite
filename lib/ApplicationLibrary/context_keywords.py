from robot.api.deco import keyword
from ApplicationLibrary.exec_context import GlobalContext, ExecContext


class ContextKeywords:
    """Keywords for execution context management"""

    @staticmethod
    @keyword
    def define_global_context(items: list[dict] | None = None) -> GlobalContext:
        """
        Creates global context object

        Parameters:
            - *``items``*: list of dictionaries that represent items
        """
        return GlobalContext(items)

    @staticmethod
    @keyword
    def dispose_global_context() -> None:
        """Disposes global context object"""
        pass

    @staticmethod
    @keyword
    def define_exec_context() -> ExecContext:
        """Creates execution context object"""
        return ExecContext()

    @staticmethod
    @keyword
    def dispose_exec_context() -> None:
        """Disposes execution context object"""
        pass
