*** Settings ***
Documentation
...                 API Customers keywords:
...                 - ``API Create Customer``    Creates customer using API Create Customer
...                 - ``Populate Customer Name``    Adds ``FakeItLibrary.Fake Customer Name`` to the Create Customer request body
...                 - ``Populate Customer Email``    Adds ``FakeItLibrary.Fake Customer Email`` to the Create Customer request body
...                 - ``Validate Create Customer Success Response``    Validates given successful API Create Customer response
...                 - ``Validate Get Customer Success Response``    Validates given successful API Get Customer response
...                 - ``Validate Get Customers Success Response``    Validates given successful API Get Customers response
...

Resource            project_settings.resource
Variables           api_customers_jsd.py


*** Keywords ***
API Create Customer
    [Documentation]
    ...    Creates customer using API Create Customer and saves it in the selected context
    ...
    ...    Parameters:
    ...    - ``name``    customer name, default ``EMPTY``
    ...    - ``email``    customer email, default ``EMPTY``
    ...    - ``scope``    context to work with, ``SUITES``, ``SUITE`` or ``TEST``, default is current scope
    ...
    ...    The ``parameters`` are processed as follows:
    ...    - when ``parameter`` is ``None`` it is not populated
    ...    - when ``parameter`` is ``EMPTY`` a ``FakeItLibrary`` is used to populate the value
    ...    - otherwise given ``parameter`` is populated
    ...
    [Arguments]    ${name}=${EMPTY}    ${email}=${EMPTY}    ${scope}=${SCOPE}
    ${body}    Create Dictionary
    ${name}    Populate Customer Name    ${body}    ${name}
    ${email}    Populate Customer Email    ${body}    ${email}
    Set Operation User    scope=${scope}
    Set Operation Start    scope=${scope}
    ${response}    Do POST    API    customers/    ${body}
    Set Operation End    scope=${scope}
    ${c}    Define Customer    ${response.json()}[id]    ${name}    ${email}    scope=${scope}
    RETURN    ${c}

Populate Customer Name
    [Documentation]
    ...    Adds name to the Create Customer request body
    ...
    ...    Parameters:
    ...    - ``body``    request body as a dictionary
    ...    - ``name``    the name to add
    ...
    ...    The ``name`` is processed as follows:
    ...    - when ``name`` is ``None`` it is not added to the ``body``
    ...    - when ``name`` is ``EMPTY`` a ``FakeItLibrary.Fake Customer Name`` is added to the ``body``
    ...    - otherwise given ``name`` is added to the ``body``
    ...
    ...    Returns:
    ...    - request ``body`` (changes given ``body`` dictionary)
    ...    - ``name``
    ...
    [Arguments]    ${body}    ${name}
    IF    $name == ""
        ${name}    Fake Customer Name
    END
    IF    $name
        ${body}[name]    Set Variable    ${name}
    END
    RETURN    ${name}

Populate Customer Email
    [Documentation]
    ...    Adds email to the Create Customer request body
    ...
    ...    Parameters:
    ...    - ``body``    request body as a dictionary
    ...    - ``email``    the email to add
    ...
    ...    The ``email`` is processed as follows:
    ...    - when ``email`` is ``None`` it is not added to the ``body``
    ...    - when ``email`` is ``EMPTY`` a ``FakeItLibrary.Fake Customer Email`` is added to the ``body``
    ...    - otherwise given ``email`` is added to the ``body``
    ...
    ...    Returns:
    ...    - request ``body`` (changes given ``body`` dictionary)
    ...    - ``email``
    ...
    [Arguments]    ${body}    ${email}
    IF    $email == ""
        ${email}    Fake Customer Email
    END
    IF    $email
        ${body}[email]    Set Variable    ${email}
    END
    RETURN    ${email}

Validate Create Customer Success Response
    [Documentation]
    ...    Validates given API response:
    ...    - response headers content type
    ...    - response HTTP status code
    ...    - response body schema
    ...
    ...    Parameters:
    ...    - ``response``    response to be validated
    ...
    [Arguments]    ${response}
    Validate API Response Template
    ...    ${response}
    ...    ${JSD_CREATE_CUSTOMER_SUCCESS}
    ...    application/json
    ...    ${201}

Validate Get Customer Success Response
    [Documentation]
    ...    Validates given API response:
    ...    - response headers content type
    ...    - response HTTP status code
    ...    - response body schema
    ...
    ...    Parameters:
    ...    - ``response``    response to be validated
    ...
    [Arguments]    ${response}
    Validate API Response Template
    ...    ${response}
    ...    ${JSD_CREATE_CUSTOMER_SUCCESS}
    ...    application/json
    ...    ${200}

Validate Get Customers Success Response
    [Documentation]
    ...    Validates given API response:
    ...    - response headers content type
    ...    - response HTTP status code
    ...    - response body schema
    ...
    ...    Parameters:
    ...    - ``response``    response to be validated
    ...
    [Arguments]    ${response}
    Validate API Response Template
    ...    ${response}
    ...    ${JSD_GET_CUSTOMERS_SUCCESS}
    ...    application/json
    ...    ${200}
