*** Settings ***
Documentation       Suite and test data validation keywords

Resource            project_settings.resource


*** Keywords ***
Validate Customers
    [Arguments]    @{customers}
    ${expected}    Create List
    ${customer_ids}    Create List
    FOR    ${customer}    IN    @{customers}
        Append To List    ${expected}    ${customer.row}
        Append To List    ${customer_ids}    ${customer.id}
    END
    ${expected}    Evaluate    sorted([customer_row for customer_row in $expected], key=lambda x: x[0])
    ${result}    PG Get Customers By Ids    @{customer_ids}
    Lists Should Be Equal    ${expected}    ${result}    Customers are not as expected

Validate Test Data
    [Arguments]    ${scope}=${SCOPE}
    ${result}    PG Get Customers By Ids    @{${scope}_CONTEXT.customer_ids}
    Lists Should Be Equal    ${${scope}_CONTEXT.customer_rows}    ${result}    Customers are not as expected
