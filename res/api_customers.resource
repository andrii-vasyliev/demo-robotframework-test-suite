*** Settings ***
Documentation
...                 API Customers keywords:
...                 - *``API Create Customer``*    Creates customer using API Create Customer
...                 - *``Populate Customer Name``*    Adds *``FakeItLibrary.Fake Customer Name``* to the Create Customer request body
...                 - *``Populate Customer Email``*    Adds *``FakeItLibrary.Fake Customer Email``* to the Create Customer request body
...                 - *``Validate Create Customer Success Response``*    Validates given successful API Create Customer response
...                 - *``Validate Get Customer Success Response``*    Validates given successful API Get Customer response
...                 - *``Validate Get Customers Success Response``*    Validates given successful API Get Customers response
...

Resource            project_settings.resource
Variables           api_customers_jsd.py


*** Keywords ***
API Create Customer
    [Documentation]
    ...    Creates customer using API Create Customer and saves it in the current context
    ...
    ...    Parameters:
    ...    - *``locale``*    use given locale, default *``${LOCALE}``*
    ...    - *``body``*    Create Customer request body, default *``EMPTY``*
    ...
    ...    See *``Populate Create Customer Body``* for more details on how the request body is populated
    ...
    [Arguments]    ${locale}=${LOCALE}    &{body}
    ${body}    Populate Create Customer Body    locale=${locale}    body=${body}
    Event Audit Start
    ${response}    Do POST    API    customers/    ${body}
    Event Audit End
    ${c}    Define Customer    ${response.json()}[id]    ${body}    scope=${SCOPE}
    RETURN    ${c}

Validate Create Customer Success Response
    [Documentation]
    ...    Validates given API response:
    ...    - response headers content type
    ...    - response HTTP status code
    ...    - response body schema
    ...
    ...    Parameters:
    ...    - *``response``*    response to be validated
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
    ...    - *``response``*    response to be validated
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
    ...    - *``response``*    response to be validated
    ...
    [Arguments]    ${response}
    Validate API Response Template
    ...    ${response}
    ...    ${JSD_GET_CUSTOMERS_SUCCESS}
    ...    application/json
    ...    ${200}
