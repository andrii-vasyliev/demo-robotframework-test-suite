*** Settings ***
Documentation       Basic project keywords:
...                 - ``Project Setup``    Performs basic test project setup
...                 - ``Project Teardown``    Performs basic test project teardown
...                 - ``Basic Suites Setup``    Performs basic suites setup (context is accessible in current suite and its sub-suites)
...                 - ``Basic Suites Teardown``    Performs basic suites teardown
...                 - ``Basic Suite Setup``    Performs basic suite setup (context is accessible only in current suite)
...                 - ``Basic Suite Teardown``    Performs basic suite teardown
...                 - ``Basic Test Setup``    Performs basic test case setup
...                 - ``Basic Test Teardown``    Performs basic test case teardown
...                 - ``Set Operation Start``    Sets operation start date/time using current PostgreSQL date/time
...                 - ``Set Operation End``    Sets operation end date/time using current PostgreSQL date/time
...                 - ``Set Operation User``    Sets operation user

Resource            project_settings.resource


*** Variables ***
${GLOBAL_CONTEXT}       ${None}
${SUITES_CONTEXT}       ${None}
${SUITE_CONTEXT}        ${None}
${TEST_CONTEXT}         ${None}
${SCOPE}                ${None}
${GLOBAL}               ${{ ApplicationLibrary.exec_context.GlobalContextType.GLOBAL }}
${SUITES}               ${{ ApplicationLibrary.exec_context.ExecContextType.SUITES }}
${SUITE}                ${{ ApplicationLibrary.exec_context.ExecContextType.SUITE }}
${TEST}                 ${{ ApplicationLibrary.exec_context.ExecContextType.TEST }}


*** Keywords ***
Project Setup
    [Documentation]
    ...    Performs basic project setup:
    ...    - connects to PostgreSQL
    ...    - initialize global context object
    ...
    Pgsql Connect    ${DATABASE_URL}
    ${catalog}    Pgsql Query    SELECT ecommerce.rf_get_items()
    ${catalog}    Evaluate    tuple(i[0] for i in $catalog)
    ${GLOBAL_CONTEXT}    Define Global Context    ${catalog}
    VAR    ${GLOBAL_CONTEXT}    ${GLOBAL_CONTEXT}    scope=${GLOBAL}

Project Teardown
    [Documentation]
    ...    Performs basic project teardown:
    ...    - closes PostgreSQL connection
    ...    - disposes global context object
    ...
    Pgsql Close
    Dispose Global Context

Basic Suites Setup
    [Documentation]
    ...    Performs basic suites setup:
    ...    - defines suites execution context
    ...
    ...    Context is accessible in current suite and its sub-suites
    ...
    ${SUITES_CONTEXT}    Define Suite Context
    VAR    ${SUITES_CONTEXT}    ${SUITES_CONTEXT}    scope=${SUITES}
    VAR    ${SCOPE}    ${SUITES}    scope=${SUITES}

Basic Suites Teardown
    [Documentation]
    ...    Performs basic suites teardown:
    ...    - disposes suites execution context
    ...
    Dispose Suite Context
    VAR    ${SCOPE}    ${None}    scope=${SUITES}
    VAR    ${SUITES_CONTEXT}    ${None}    scope=${SUITES}

Basic Suite Setup
    [Documentation]
    ...    Performs basic suite setup:
    ...    - defines suite execution context
    ...
    ...    Context is accessible only in current suite
    ...
    ${SUITE_CONTEXT}    Define Suite Context
    VAR    ${SUITE_CONTEXT}    ${SUITE_CONTEXT}    scope=${SUITE}
    VAR    ${SCOPE}    ${SUITE}    scope=${SUITE}

Basic Suite Teardown
    [Documentation]
    ...    Performs basic suite teardown:
    ...    - disposes suite execution context
    ...
    Dispose Suite Context
    VAR    ${SCOPE}    ${None}    scope=${SUITE}
    VAR    ${SUITE_CONTEXT}    ${None}    scope=${SUITE}

Basic Test Setup
    [Documentation]
    ...    Performs basic test case setup:
    ...    - defines test execution context
    ...
    ${TEST_CONTEXT}    Define Test Context
    VAR    ${TEST_CONTEXT}    ${TEST_CONTEXT}    scope=${TEST}
    VAR    ${SCOPE}    ${TEST}    scope=${TEST}

Basic Test Teardown
    [Documentation]
    ...    Performs basic test case teardown:
    ...    - disposes test execution context
    ...
    Dispose Test Context
    VAR    ${SCOPE}    ${None}    scope=${TEST}
    VAR    ${TEST_CONTEXT}    ${None}    scope=${TEST}

Set Operation Start
    [Documentation]
    ...    Sets operation start date/time using current PostgreSQL date/time
    ...
    ...    Operation start/end date/time is used by other keywords
    ...    to determine if create date of the object is acceptable.
    ...
    ...    Parameters:
    ...    - ``scope``    context to work with, ``SUITES``, ``SUITE`` or ``TEST``, default current scope
    ...
    [Arguments]    ${scope}=${SCOPE}
    ${result}    Pgsql Query    SELECT current_timestamp
    ${${scope.upper()}_CONTEXT.audit_info.timestamp.start_date}    Set Variable    ${result}[0][0]

Set Operation End
    [Documentation]
    ...    Sets operation end date/time using current PostgreSQL date/time
    ...
    ...    Operation start/end date/time is used by other keywords
    ...    to determine if create date of the object is acceptable.
    ...
    ...    Parameters:
    ...    - ``scope``    context to work with, ``SUITES``, ``SUITE`` or ``TEST``, default current scope
    ...
    [Arguments]    ${scope}=${SCOPE}
    ${result}    Pgsql Query    SELECT current_timestamp
    ${${scope.upper()}_CONTEXT.audit_info.timestamp.end_date}    Set Variable    ${result}[0][0]

Set Operation User
    [Documentation]
    ...    Sets operation user
    ...
    ...    Operation user is used by other keywords
    ...    to determine if the object is created by expected user.
    ...
    ...    Parameters:
    ...    - ``user_name``    user name that is an author of the operation, default ``api``
    ...    - ``scope``    context to work with, ``SUITES``, ``SUITE`` or ``TEST``, default current scope
    ...
    [Arguments]    ${user_name}=api    ${scope}=${SCOPE}
    ${${scope.upper()}_CONTEXT.audit_info.user}    Set Variable    ${user_name}
