*** Settings ***
Documentation       Data validation keywords:
...                 - *``Validate Customers``*    Validates given list of customer objects against data stored in the system.
...                 - *``Validate Test Data``*    Validates data stored in the context against data stored in the system.

Resource            project_settings.resource


*** Keywords ***
Validate Customers
    [Documentation]
    ...    Validates given list of customer objects against data stored in the system.
    ...
    ...    Parameters:
    ...    - *``@customer_ids``*    positional arguments that represent a list of customer Ids
    ...
    [Arguments]    @{customers}
    ${customer_ids}    Evaluate    [customer.id for customer in $customers]
    ${expected}    Evaluate    sorted([customer.row for customer in $customers], key=lambda x: x[0])
    ${result}    PG Get Customers By Ids    @{customer_ids}
    Lists Should Be Equal    ${expected}    ${result}    Customers are not as expected

Validate Test Data
    [Documentation]
    ...    Validates data stored in the context against data stored in the system.
    ...
    ...    Parameters:
    ...    - *``scope``*    scope of the context to be validated
    ...
    [Arguments]    ${scope}=${SCOPE}
    ${result}    PG Get Customers By Ids    @{${scope.upper()}_CONTEXT.customer_ids}
    Lists Should Be Equal    ${${scope.upper()}_CONTEXT.customer_rows}    ${result}    Customers are not as expected
