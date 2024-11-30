*** Settings ***
Documentation       API Get Customer by parameters valid requests test cases
Metadata            https://company-jira.atlassian.com/browse/original-requirement
Metadata            https://company-jira.atlassian.com/browse/change-request

Resource            ../../../../res/project_settings.resource
Resource            ../res/customers_helper.robot

Suite Setup         Suite Setup
Suite Teardown      Basic Suite Teardown
Test Setup          Basic Test Setup
Test Teardown       Basic Test Teardown


*** Test Cases ***
Get customer by Id
    [Documentation]    Get customer by Id
    ...
    ...    - Get existing customer by Id
    ...
    [Template]    Get Customer By Id Valid Request
    ${${SUITE}_CONTEXT.customers[1]}

Repeated get customer by Id
    [Documentation]    Repeat the same get customer by Id request
    ...
    ...    - Repeated GET request returns the same result
    ...    See test case details in the *``Get customer by Id``*
    ...
    [Template]    Get Customer By Id Valid Request
    ${${SUITE}_CONTEXT.customers[1]}

Get single customer by name
    [Documentation]    Get single customer by name
    ...
    ...    - Get single customer that has no email by name query parameter only
    ...    - Get single customer that has no email by name and empty email query parameters
    ...    - Get single customer that has no email by name and "any" email query parameters
    ...    - Get single customer that has email by name query parameter only
    ...    - Get single customer that has email by name and "any" email query parameters
    ...
    [Template]    Get Customers By Parameters Valid Request
    ${${SUITE}_CONTEXT.customers[0].name}    ${None}    ${${SUITE}_CONTEXT.customers[0]}
    ${${SUITE}_CONTEXT.customers[0].name}    ${EMPTY}    ${${SUITE}_CONTEXT.customers[0]}
    ${${SUITE}_CONTEXT.customers[0].name}    any    ${${SUITE}_CONTEXT.customers[0]}
    ${${SUITE}_CONTEXT.customers[4].name}    ${None}    ${${SUITE}_CONTEXT.customers[4]}
    ${${SUITE}_CONTEXT.customers[4].name}    any    ${${SUITE}_CONTEXT.customers[4]}

Repeated get single customer by name
    [Documentation]    Repeat the same get single customer by name request
    ...
    ...    - Repeated GET request returns the same result
    ...    See test case details in the *``Get single customer by name``*
    ...
    [Template]    Get Customers By Parameters Valid Request
    ${${SUITE}_CONTEXT.customers[0].name}    ${None}    ${${SUITE}_CONTEXT.customers[0]}
    ${${SUITE}_CONTEXT.customers[0].name}    ${EMPTY}    ${${SUITE}_CONTEXT.customers[0]}
    ${${SUITE}_CONTEXT.customers[0].name}    any    ${${SUITE}_CONTEXT.customers[0]}
    ${${SUITE}_CONTEXT.customers[4].name}    ${None}    ${${SUITE}_CONTEXT.customers[4]}
    ${${SUITE}_CONTEXT.customers[4].name}    any    ${${SUITE}_CONTEXT.customers[4]}

Get multiple customers by name
    [Documentation]    Get multiple customers by name
    ...
    ...    - Get multiple customers by name query parameter only
    ...    - Get multiple customers by name and empty email query parameters
    ...    - Get multiple customers by name and "any" email query parameters
    ...
    [Template]    Get Customers By Parameters Valid Request
    ${${SUITE}_CONTEXT.customers[1].name}    ${None}    @{${SUITE}_CONTEXT.customers[1:4]}
    ${${SUITE}_CONTEXT.customers[1].name}    ${EMPTY}    ${${SUITE}_CONTEXT.customers[3]}
    ${${SUITE}_CONTEXT.customers[1].name}    any    @{${SUITE}_CONTEXT.customers[1:4]}

Repeat get multiple customers by name
    [Documentation]    Repeat the same get multiple customers by name request
    ...
    ...    - Repeated GET request returns the same result
    ...    See test case details in the *``Get multiple customers by name``*
    ...
    [Template]    Get Customers By Parameters Valid Request
    ${${SUITE}_CONTEXT.customers[1].name}    ${None}    @{${SUITE}_CONTEXT.customers[1:4]}
    ${${SUITE}_CONTEXT.customers[1].name}    ${EMPTY}    ${${SUITE}_CONTEXT.customers[3]}
    ${${SUITE}_CONTEXT.customers[1].name}    any    @{${SUITE}_CONTEXT.customers[1:4]}

Get single customer by email
    [Documentation]    Get single customer by email
    ...
    ...    - Get single customer by email query parameter only
    ...    - Get single customer by email and empty name query parameters
    ...
    [Template]    Get Customers By Parameters Valid Request
    ${None}    ${${SUITE}_CONTEXT.customers[2].email}    ${${SUITE}_CONTEXT.customers[2]}
    ${EMPTY}    ${${SUITE}_CONTEXT.customers[2].email}    ${${SUITE}_CONTEXT.customers[2]}

Repeated get single customer by email
    [Documentation]    Repeat the same get single customer by email
    ...
    ...    - Repeated GET request returns the same result
    ...    See test case details in the *``Get single customer by email``*
    ...
    [Template]    Get Customers By Parameters Valid Request
    ${None}    ${${SUITE}_CONTEXT.customers[2].email}    ${${SUITE}_CONTEXT.customers[2]}
    ${EMPTY}    ${${SUITE}_CONTEXT.customers[2].email}    ${${SUITE}_CONTEXT.customers[2]}

Get multiple customers by email
    [Documentation]    Get multiple customers by email
    ...
    ...    - Get multiple customers by email query parameter only
    ...    - Get multiple customers by email and empty name query parameters
    ...
    [Template]    Get Customers By Parameters Valid Request
    ${None}    ${${SUITE}_CONTEXT.customers[1].email}    ${${SUITE}_CONTEXT.customers[1]}    ${${SUITE}_CONTEXT.customers[4]}
    ${EMPTY}    ${${SUITE}_CONTEXT.customers[1].email}    ${${SUITE}_CONTEXT.customers[1]}    ${${SUITE}_CONTEXT.customers[4]}

Repeated get multiple customers by email
    [Documentation]    Repeat the same get multiple customers by email
    ...
    ...    - Repeated GET request returns the same result
    ...    See test case details in the *``Get multiple customers by email``*
    ...
    [Template]    Get Customers By Parameters Valid Request
    ${None}    ${${SUITE}_CONTEXT.customers[1].email}    ${${SUITE}_CONTEXT.customers[1]}    ${${SUITE}_CONTEXT.customers[4]}
    ${EMPTY}    ${${SUITE}_CONTEXT.customers[1].email}    ${${SUITE}_CONTEXT.customers[1]}    ${${SUITE}_CONTEXT.customers[4]}

Get customer by name and email
    [Documentation]    Get customer by name and email
    ...
    ...    - Get customer by both name and email query parameters
    ...
    [Template]    Get Customers By Parameters Valid Request
    ${${SUITE}_CONTEXT.customers[1].name}    ${${SUITE}_CONTEXT.customers[1].email}    ${${SUITE}_CONTEXT.customers[1]}

Repeated get customer by name and email
    [Documentation]    Repeat the same get customer by name and email
    ...
    ...    - Repeated GET request returns the same result
    ...    See test case details in the *``Get customer by name and email``*
    ...
    [Template]    Get Customers By Parameters Valid Request
    ${${SUITE}_CONTEXT.customers[1].name}    ${${SUITE}_CONTEXT.customers[1].email}    ${${SUITE}_CONTEXT.customers[1]}

Get customer by some unknown query parameter in addition to known
    [Documentation]    Get customer by some unknown query parameter in addition to known
    ...
    ...    - Unknown query parameter is ignored
    ...
    [Template]    Get Customers By Parameters Valid Request
    ${${SUITE}_CONTEXT.customers[1].name}    ${${SUITE}_CONTEXT.customers[1].email}    ${${SUITE}_CONTEXT.customers[1]}    another_param=some value

Repeated get customer by some unknown query parameter in addition to known
    [Documentation]    Repeat the same get customer by some unknown query parameter in addition to known
    ...
    ...    - Repeated GET request returns the same result
    ...    See test case details in the *``Get customer by some unknown query parameter in addition to known``*
    ...
    [Template]    Get Customers By Parameters Valid Request
    ${${SUITE}_CONTEXT.customers[1].name}    ${${SUITE}_CONTEXT.customers[1].email}    ${${SUITE}_CONTEXT.customers[1]}    another_param=some value


*** Keywords ***
Suite Setup
    [Documentation]    Performs basic test setup and creates few customers to use in the test cases.
    Basic Suite Setup
    API Create Customer    email=${None}
    API Create Customer
    API Create Customer    ${${SUITE}_CONTEXT.customers[1].name}
    API Create Customer    ${${SUITE}_CONTEXT.customers[1].name}    ${None}
    API Create Customer    email=${${SUITE}_CONTEXT.customers[1].email}
    Validate Test Data
