*** Settings ***
Documentation       API Get Customer by parameters invalid requests test cases
Metadata            https://company-jira.atlassian.com/browse/original-requirement
Metadata            https://company-jira.atlassian.com/browse/change-request

Resource            ../../../../res/project_settings.resource
Resource            ../res/customers_helper.robot

Suite Setup         Suite Setup
Suite Teardown      Basic Suite Teardown
Test Setup          Basic Test Setup
Test Teardown       Basic Test Teardown


*** Variables ***
&{TEXT_ACCEPT_HEADERS}      Accept=text/plain


*** Test Cases ***
Customer Id is wrong or unknown
    [Documentation]    Customer Id is wrong or unknown
    ...
    ...    - Request to get customer by unknown Id is rejected
    ...    - Request to get customers without specified query parameters is rejected
    ...    - Request to get customer by invalid UUID-like Id is rejected
    ...    - Request to get customer by invalid Id is rejected
    ...
    [Template]    Get Customer By Id Invalid Request
    ${404}    Customer not found    customer_id=01a67c37-81b4-489c-9f2e-0e857c148bf2
    ${400}    At least one search parameter is required
    ${422}    UUID version 4 expected    customer_id=00000000-0000-0000-0000-000000000000
    ${422}    Input should be a valid UUID    customer_id=not UUID

Get customer by unknown path
    [Documentation]    Get customer by unknown path
    ...
    ...    - Request to unknown path is rejected
    ...
    [Template]    Get Customer By Id Invalid Request
    ${404}    Not found    customer_id=01a67c37-81b4-489c-9f2e-0e857c148bf2/name/Mr.+Anonymous+Incognito

Customer name or email is unknown
    [Documentation]    Customer name or email is unknown
    ...
    ...    - Request to get customers by unknown name is rejected
    ...    - Request to get customers by unknown email is rejected
    ...    - Request to get customers by invalid email is rejected
    ...
    [Template]    Get Customers By Parameters Invalid Request
    ${404}    Customer not found    name=Mr. Anonymous Incognito
    ${404}    Customer not found    email=unknown@email.eu
    ${404}    Customer not found    email=unknown

Exact value of query parameters is not provided
    [Documentation]    Exact value of query parameters is not provided
    ...
    ...    - Request to get customers by empty name query parameter only is rejected
    ...    - Request to get customers by empty email query parameter only is rejected
    ...    - Request to get customers by "any" email query parameter only is rejected
    ...    - Request to get customers by empty name and email query parameters is rejected
    ...    - Request to get customers by empty name and "any" email query parameters is rejected
    ...
    [Template]    Get Customers By Parameters Invalid Request
    ${400}    At least one search parameter is required    name=${EMPTY}
    ${400}    At least one search parameter is required    email=${EMPTY}
    ${400}    At least one search parameter is required    email=any
    ${400}    At least one search parameter is required    name=${EMPTY}    email=${EMPTY}
    ${400}    At least one search parameter is required    name=${EMPTY}    email=any

Get customer by unknown parameters
    [Documentation]    Get customer by unknown parameters
    ...
    ...    - Request to get customers by unknown query parameters is rejected
    ...
    [Template]    Get Customers By Parameters Invalid Request
    ${400}    At least one search parameter is required    first_name=${${SUITE}_CONTEXT.customers[0].name}    default_email=${${SUITE}_CONTEXT.customers[0].email}

Get customer with wrong MIME type
    [Documentation]    Get customer with wrong MIME type
    ...
    ...    - Request to get existing customer by Id with unsupported Accept headers MIME type is rejected
    ...    - Request to get existing customer by query parameters with unsupported Accept headers MIME type is rejected
    ...
    Get Customer By Id Invalid Request
    ...    ${406}
    ...    This endpoint only supports application/json responses
    ...    ${{ {"headers": ${TEXT_ACCEPT_HEADERS}} }}
    ...    ${${SUITE}_CONTEXT.customers[0].id}
    Get Customers By Parameters Invalid Request
    ...    ${406}
    ...    This endpoint only supports application/json responses
    ...    ${{ {"headers": ${TEXT_ACCEPT_HEADERS}} }}
    ...    name=${${SUITE}_CONTEXT.customers[0].name}
    ...    email=${${SUITE}_CONTEXT.customers[0].email}

SQL injections
    [Documentation]    SQL injections
    ...
    ...    - Request to get customer by Id with SQL injection is rejected
    ...    - Request to get customer by name with SQL injection is rejected
    ...    - Request to get customer by email with SQL injection is rejected
    ...    - Request to get customer by name and email with SQL injection is rejected
    ...
    Get Customer By Id Invalid Request
    ...    ${422}
    ...    Input should be a valid UUID
    ...    customer_id=${${SUITE}_CONTEXT.customers[0].id}' or ''='
    Get Customers By Parameters Invalid Request
    ...    ${404}
    ...    Customer not found
    ...    name=${${SUITE}_CONTEXT.customers[0].name}' or ''='
    Get Customers By Parameters Invalid Request
    ...    ${404}
    ...    Customer not found
    ...    email=${${SUITE}_CONTEXT.customers[0].email}' or ''='
    Get Customers By Parameters Invalid Request
    ...    ${404}
    ...    Customer not found
    ...    name=${${SUITE}_CONTEXT.customers[0].name}' or ''='
    ...    email=${${SUITE}_CONTEXT.customers[0].email}' or ''='


*** Keywords ***
Suite Setup
    [Documentation]    Performs basic test setup and creates a customer to use in the test cases.
    Basic Suite Setup
    API Create Customer
    Validate Test Data
