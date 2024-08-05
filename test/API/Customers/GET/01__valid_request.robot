*** Settings ***
Documentation       API Get Customer by parameters valid requests test cases

Resource            ../../../../res/project_settings.resource
Resource            ../res/customers_helper.robot

Suite Setup         Suite Setup
Suite Teardown      Basic Suite Teardown
Test Setup          Basic Test Setup
Test Teardown       Basic Test Teardown


*** Test Cases ***
Get customer by Id
    [Template]    Get Customer By Id Valid Request
    ${SUITE_CONTEXT.customers[1]}

Get single customer by name
    [Template]    Get Customers By Parameters Valid Request
    # Customer with no email
    ${SUITE_CONTEXT.customers[0].name}    ${None}    ${SUITE_CONTEXT.customers[0]}
    ${SUITE_CONTEXT.customers[0].name}    ${EMPTY}    ${SUITE_CONTEXT.customers[0]}
    ${SUITE_CONTEXT.customers[0].name}    any    ${SUITE_CONTEXT.customers[0]}
    # Customer with email
    ${SUITE_CONTEXT.customers[4].name}    ${None}    ${SUITE_CONTEXT.customers[4]}
    ${SUITE_CONTEXT.customers[4].name}    any    ${SUITE_CONTEXT.customers[4]}

Get multiple customers by name
    [Template]    Get Customers By Parameters Valid Request
    ${SUITE_CONTEXT.customers[1].name}    ${None}    @{SUITE_CONTEXT.customers[1:4]}
    ${SUITE_CONTEXT.customers[1].name}    ${EMPTY}    ${SUITE_CONTEXT.customers[3]}
    ${SUITE_CONTEXT.customers[1].name}    any    @{SUITE_CONTEXT.customers[1:4]}

Get single customer by email
    [Template]    Get Customers By Parameters Valid Request
    ${None}    ${SUITE_CONTEXT.customers[2].email}    ${SUITE_CONTEXT.customers[2]}
    ${EMPTY}    ${SUITE_CONTEXT.customers[2].email}    ${SUITE_CONTEXT.customers[2]}

Get multiple customers by email
    [Template]    Get Customers By Parameters Valid Request
    ${None}    ${SUITE_CONTEXT.customers[1].email}    ${SUITE_CONTEXT.customers[1]}    ${SUITE_CONTEXT.customers[4]}
    ${EMPTY}    ${SUITE_CONTEXT.customers[1].email}    ${SUITE_CONTEXT.customers[1]}    ${SUITE_CONTEXT.customers[4]}

Get customer by name and email
    [Template]    Get Customers By Parameters Valid Request
    ${SUITE_CONTEXT.customers[1].name}    ${SUITE_CONTEXT.customers[1].email}    ${SUITE_CONTEXT.customers[1]}

Get customer by some unknown parameter in addition
    [Template]    Get Customers By Parameters Valid Request
    ${SUITE_CONTEXT.customers[1].name}    ${SUITE_CONTEXT.customers[1].email}    ${SUITE_CONTEXT.customers[1]}    another_param=some value


*** Keywords ***
Suite Setup
    Basic Suite Setup
    API Create Customer    email=${None}
    API Create Customer
    API Create Customer    ${SUITE_CONTEXT.customers[1].name}
    API Create Customer    ${SUITE_CONTEXT.customers[1].name}    ${None}
    API Create Customer    email=${SUITE_CONTEXT.customers[1].email}
    Validate Test Data
