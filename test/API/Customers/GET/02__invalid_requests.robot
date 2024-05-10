*** Settings ***
Documentation       API Get Customer by parameters invalid requests test cases

Resource            ../../../../res/project_settings.resource
Resource            ../res/customers_helper.robot

Suite Setup         Suite Setup
Suite Teardown      Basic Suite Teardown
Test Setup          Basic Test Setup
Test Teardown       Basic Test Teardown


*** Test Cases ***
Customer Id is wrong or unknown
    [Template]    Get Customer By Id Invalid Request
    ${404}    Customer not found    01a67c37-81b4-489c-9f2e-0e857c148bf2
    ${400}    At least one search parameter is required    ${EMPTY}
    ${422}    UUID version 4 expected    00000000-0000-0000-0000-000000000000
    ${422}    Input should be a valid UUID    not UUID

Get customer by unknown path
    [Template]    Get Customer By Id Invalid Request
    ${404}    Not found    01a67c37-81b4-489c-9f2e-0e857c148bf2/name/Mr.+Incognito

Customer name or email is unknown
    [Template]    Get Customers By Parameters Invalid Request
    ${404}    Customer not found    name=Mr. Incognito
    ${404}    Customer not found    email=unknown
    ${400}    At least one search parameter is required    name=${EMPTY}    email=${EMPTY}
    ${400}    At least one search parameter is required    email=any
    ${400}    At least one search parameter is required    name=${EMPTY}    email=any

Get customer by unknown parameters
    [Template]    Get Customers By Parameters Invalid Request
    ${400}    At least one search parameter is required    first_name=${SUITE_CONTEXT.customers[0].name}    default_email=${SUITE_CONTEXT.customers[0].email}

SQL injections
    Get Customer By Id Invalid Request
    ...    ${422}
    ...    Input should be a valid UUID
    ...    ${SUITE_CONTEXT.customers[0].id}' or ''='
    Get Customers By Parameters Invalid Request
    ...    ${404}
    ...    Customer not found
    ...    name=${SUITE_CONTEXT.customers[0].name}' or ''='
    Get Customers By Parameters Invalid Request
    ...    ${404}
    ...    Customer not found
    ...    email=${SUITE_CONTEXT.customers[0].email}' or ''='
    Get Customers By Parameters Invalid Request
    ...    ${404}
    ...    Customer not found
    ...    name=${SUITE_CONTEXT.customers[0].name}' or ''='
    ...    email=${SUITE_CONTEXT.customers[0].email}' or ''='


*** Keywords ***
Suite Setup
    Basic Suite Setup
    API Create Customer
    Validate Test Data
