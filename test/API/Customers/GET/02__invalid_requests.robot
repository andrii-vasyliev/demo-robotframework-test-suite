*** Settings ***
Documentation       API Get Customer by parameters invalid requests test cases

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
    [Template]    Get Customer By Id Invalid Request
    ${404}    Customer not found    customer_id=01a67c37-81b4-489c-9f2e-0e857c148bf2
    ${400}    At least one search parameter is required
    ${422}    UUID version 4 expected    customer_id=00000000-0000-0000-0000-000000000000
    ${422}    Input should be a valid UUID    customer_id=not UUID

Get customer by unknown path
    [Template]    Get Customer By Id Invalid Request
    ${404}    Not found    customer_id=01a67c37-81b4-489c-9f2e-0e857c148bf2/name/Mr.+Anonymous+Incognito

Customer name or email is unknown
    [Template]    Get Customers By Parameters Invalid Request
    ${404}    Customer not found    name=Mr. Anonymous Incognito
    ${404}    Customer not found    email=unknown

Exact value of query parameters is not provided
    [Template]    Get Customers By Parameters Invalid Request
    ${400}    At least one search parameter is required    name=${EMPTY}
    ${400}    At least one search parameter is required    email=${EMPTY}
    ${400}    At least one search parameter is required    email=any
    ${400}    At least one search parameter is required    name=${EMPTY}    email=${EMPTY}
    ${400}    At least one search parameter is required    name=${EMPTY}    email=any

Get customer by unknown parameters
    [Template]    Get Customers By Parameters Invalid Request
    ${400}    At least one search parameter is required    first_name=${${SUITE}_CONTEXT.customers[0].name}    default_email=${${SUITE}_CONTEXT.customers[0].email}

Get customer with wrong Mimetype
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

SQL injections
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
    Basic Suite Setup
    API Create Customer
    Validate Test Data
