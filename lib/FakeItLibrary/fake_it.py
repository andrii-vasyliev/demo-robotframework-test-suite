from enum import StrEnum
from faker import Faker
from robot.api.deco import keyword


class Locales(StrEnum):
    EN = "en_US"
    PL = "pl_PL"
    JP = "ja_JP"
    BG = "bg_BG"


DEFAULT_LOCALE = Locales.PL

__fake = Faker([locale.value for locale in Locales], use_weighting=False)


@keyword
def fake_customer_name(locale: Locales = DEFAULT_LOCALE) -> str:
    """
    Creates fake customer name based on *``locale``*
    Supported locales: en_US, pl_PL, ja_JP, bg_BG.

    Parameters:
        - *``locale``*: locale to use for name generation. Default: pl_PL
    """
    name: str = __fake[locale].name()

    return name


@keyword
def fake_customer_email(
    locale: Locales = DEFAULT_LOCALE, replace_spaces_with: str | None = ""
) -> str:
    """
    Creates fake customer email based on *``locale``*
    Supported locales: en_US, pl_PL, ja_JP, bg_BG.

    Replaces spaces in user name with provided string:
        - *``replace_spaces_with``* is None: no replacement is done, returns user name in quotes
        - *``replace_spaces_with``* is not None: replaces spaces with provided string, returns user name with no quotes

    Parameters:
        - *``locale``*: locale to use for email generation. Default: pl_PL
        - *``replace_spaces_with``*: string to replace spaces with. Default: None
    """
    user: str = __fake[locale].name()
    if replace_spaces_with is None:
        user = '"' + user + '"'
    else:
        user = user.replace(" ", replace_spaces_with).replace("..", ".")
        if user[-1] in ".":
            user = user[:-1]

    match locale:
        case Locales.PL:
            domain: str = __fake.random_element(
                [__fake[locale].safe_domain_name(), "łódż.cą", "dąbie.kraków.org.pl"]
            )
        case Locales.EN:
            domain = __fake[locale].safe_domain_name()
        case Locales.JP:
            domain = __fake[locale].safe_domain_name()
        case Locales.BG:
            domain = __fake.random_element(
                [__fake[locale].safe_domain_name(), "поща.бг", "внимание.деца"]
            )
        case _:
            raise ValueError(f"Unsupported locale: {locale}")

    return user + "@" + domain


@keyword
def fake_string(length: int | None = None) -> str:
    """
    Creates fake string.

    If *``length``* is provided, returns random string of given length. Otherwise returns random string.

    Parameters:
        - *``length``*: length of the string to be returned. Default: None
    """
    return (
        __fake.pystr(min_chars=length, max_chars=length) if length else __fake.pystr()
    )


@keyword
def fake_domain_name(length: int | None = None) -> str:
    """
    Creates fake damain name.

    If *``length``* is provided, returns random domain name of given length. Otherwise returns random domain name.
    Domain name is always returned in lowercase.

    Parameters:
        - *``length``*: length of the domain name to be returned. Default: None
    """
    domain_name: str = __fake.domain_name()
    if length:
        while len(domain_name) < length:
            domain_name = __fake.domain_word() + "." + domain_name
        domain_name = domain_name[-length:]
        if domain_name[0] in ".-":
            domain_name = domain_name.replace(domain_name[0], __fake.pystr(1, 1), 1)

    return domain_name.lower()
