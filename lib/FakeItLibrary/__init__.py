"""Faker custom keywords library"""

from enum import StrEnum
from faker import Faker
from robot.api.deco import library, keyword


class Locales(StrEnum):
    EN = "en_US"
    PL = "pl_PL"
    JP = "ja_JP"
    RU = "ru_RU"


fake = Faker([locale.value for locale in Locales])


@library(scope="GLOBAL", version="1.0.0", auto_keywords=False)
class FakeItLibrary:
    """
    Library provides an interface for generating test data.
    """

    @staticmethod
    @keyword
    def fake_customer_name(locale: Locales = Locales.PL) -> str:
        """
        Creates fake customer name based on locale
        Supported locales: en_US, pl_PL, ja_JP, ru_RU
        Default locale: pl_PL
        """
        name: str = fake[locale].name()

        return name

    @staticmethod
    @keyword
    def fake_customer_email(
        locale: Locales = Locales.PL, replace_spaces_with: str | None = ""
    ) -> str:
        """
        Creates fake customer email based on locale
        Supported locales: en_US, pl_PL, ja_JP, ru_RU
        Default locale: pl_PL

        Replaces spaces in user name with provided string:
        - replace_spaces_with is None: no replacement, returns user name in quotes
        - replace_spaces_with is not None: replaces spaces with provided string, returns user name with no quotes
        """
        user: str = fake[locale].name()
        if replace_spaces_with is None:
            user = f'"{user}"'
        else:
            user = user.replace(" ", replace_spaces_with.strip())

        if locale == Locales.PL:
            domain: str = fake.random_element(["łódż.cą", "dąbie.kraków"])
        elif locale == Locales.EN:
            domain = fake.random_element(["gmail.com", "outlook.com"])
        elif locale == Locales.JP:
            domain = fake.random_element(["org.jp", "net.jp"])
        elif locale == Locales.RU:
            domain = fake.random_element(["почта.рф", "осторожно.дети"])
        else:
            raise ValueError(f"Unsupported locale: {locale}")

        return f"{user}@{domain}"
