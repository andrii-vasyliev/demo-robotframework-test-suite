*** Settings ***
Documentation       Suite and test data validation keywords

Resource            project_settings.resource


*** Keywords ***
Validate Customers
    [Arguments]    @{customers}
    ${customer_ids}    Evaluate    [customer.id for customer in $customers]
    ${expected}    Evaluate    sorted([customer.row for customer in $customers], key=lambda x: x[0])
    ${result}    PG Get Customers By Ids    @{customer_ids}
    Lists Should Be Equal    ${expected}    ${result}    Customers are not as expected

Validate Test Data
    [Arguments]    ${scope}=${SCOPE}
    ${result}    PG Get Customers By Ids    @{${scope}_CONTEXT.customer_ids}
    Lists Should Be Equal    ${${scope}_CONTEXT.customer_rows}    ${result}    Customers are not as expected
