*** Settings ***
Documentation       Basic project keywords:
...                 - *``Project Setup``*    Performs basic test project setup
...                 - *``Project Teardown``*    Performs basic test project teardown
...                 - *``Basic Suites Setup``*    Performs basic suites setup (context is available in current suite, its sub-suites and test cases)
...                 - *``Basic Suites Teardown``*    Performs basic suites teardown
...                 - *``Basic Suite Setup``*    Performs basic suite setup (context is available only in current suite)
...                 - *``Basic Suite Teardown``*    Performs basic suite teardown
...                 - *``Basic Test Setup``*    Performs basic test case setup (context is available only in current test case)
...                 - *``Basic Test Teardown``*    Performs basic test case teardown
...                 - *``Set Event Audit Info Start Date``*    Sets operation start date/time using current PostgreSQL date/time
...                 - *``Set Event Audit Info End Date``*    Sets operation end date/time using current PostgreSQL date/time
...                 - *``Set Event Audit Info User``*    Sets operation user
...                 - *``Event Audit Start``*    Sets operation start date/time and user
...                 - *``Event Audit End``*    Sets operation end date/time

Resource            project_settings.resource


*** Variables ***
${LOCALE}               ${{ FakeItLibrary.DEFAULT_LOCALE}}
${FAKE_IT}              ${{ FakeItLibrary.FAKE_IT}}
${SCOPE}                ${None}
${GLOBAL}               ${{ ApplicationLibrary.GLOBAL_SCOPE }}
${SUITES}               ${{ ApplicationLibrary.ExecContextScope.SUITES }}
${SUITE}                ${{ ApplicationLibrary.ExecContextScope.SUITE }}
${TEST}                 ${{ ApplicationLibrary.ExecContextScope.TEST }}
${${GLOBAL}_CONTEXT}    ${None}
${${SUITES}_CONTEXT}    ${None}
${${SUITE}_CONTEXT}     ${None}
${${TEST}_CONTEXT}      ${None}


*** Keywords ***
Project Setup
    [Documentation]
    ...    Performs basic project setup:
    ...    - connects to PostgreSQL
    ...    - initialize global context object
    ...
    ...    Global context is available globally in every suite or test case
    ...
    Pgsql Connect    ${DATABASE_URL}
    ${catalog}    Pgsql Query    SELECT robotfw.get_catalog_items()
    ${catalog}    Evaluate    tuple(i[0] for i in $catalog)
    ${${GLOBAL}_CONTEXT}    Define Global Context    ${catalog}
    VAR    ${${GLOBAL}_CONTEXT}    ${${GLOBAL}_CONTEXT}    scope=${GLOBAL}

Project Teardown
    [Documentation]
    ...    Performs basic project teardown:
    ...    - closes PostgreSQL connection
    ...    - removes all HTTP sessions
    ...    - disposes global context object
    ...
    Pgsql Close
    Delete All Sessions
    Dispose Global Context

Basic Suites Setup
    [Documentation]
    ...    Performs basic suites setup:
    ...    - defines suites execution context
    ...
    ...    Suites context is available in current suite, its sub-suites and test cases
    ...
    ${${SUITES}_CONTEXT}    Define Exec Context
    VAR    ${${SUITES}_CONTEXT}    ${${SUITES}_CONTEXT}    scope=${SUITES}
    VAR    ${SCOPE}    ${SUITES}    scope=${SUITES}

Basic Suites Teardown
    [Documentation]
    ...    Performs basic suites teardown:
    ...    - disposes suites execution context
    ...
    Dispose Exec Context
    VAR    ${SCOPE}    ${None}    scope=${SUITES}
    VAR    ${${SUITES}_CONTEXT}    ${None}    scope=${SUITES}

Basic Suite Setup
    [Documentation]
    ...    Performs basic suite setup:
    ...    - defines suite execution context
    ...
    ...    Suite context is available only in current suite
    ...
    ${${SUITE}_CONTEXT}    Define Exec Context
    VAR    ${${SUITE}_CONTEXT}    ${${SUITE}_CONTEXT}    scope=${SUITE}
    VAR    ${SCOPE}    ${SUITE}    scope=${SUITE}

Basic Suite Teardown
    [Documentation]
    ...    Performs basic suite teardown:
    ...    - disposes suite execution context
    ...
    Dispose Exec Context
    VAR    ${SCOPE}    ${None}    scope=${SUITE}
    VAR    ${${SUITE}_CONTEXT}    ${None}    scope=${SUITE}

Basic Test Setup
    [Documentation]
    ...    Performs basic test case setup:
    ...    - defines test execution context
    ...
    ...    Test context is available only in current test case
    ...
    ${${TEST}_CONTEXT}    Define Exec Context
    VAR    ${${TEST}_CONTEXT}    ${${TEST}_CONTEXT}    scope=${TEST}
    VAR    ${SCOPE}    ${TEST}    scope=${TEST}

Basic Test Teardown
    [Documentation]
    ...    Performs basic test case teardown:
    ...    - disposes test execution context
    ...
    Dispose Exec Context
    VAR    ${SCOPE}    ${None}    scope=${TEST}
    VAR    ${${TEST}_CONTEXT}    ${None}    scope=${TEST}

Set Event Audit Info Start Date
    [Documentation]
    ...    Sets operation start date/time using current PostgreSQL date/time
    ...
    ...    Operation start/end date/time is used by other keywords
    ...    to determine if create date of the object is acceptable.
    ...
    ...    Parameters:
    ...    - *``scope``*    exec context to work with, *``SUITES``*, *``SUITE``* or *``TEST``*, default is current scope
    ...
    [Arguments]    ${scope}=${SCOPE}
    IF    $scope
        ${result}    Pgsql Query    SELECT current_timestamp
        Should Not Be Empty    ${result}    Unable to get timestamp from the database
        ${${scope.upper()}_CONTEXT.audit_info.timestamp.start_date}    Set Variable    ${result}[0][0]
    END

Set Event Audit Info End Date
    [Documentation]
    ...    Sets operation end date/time using current PostgreSQL date/time
    ...
    ...    Operation start/end date/time is used by other keywords
    ...    to determine if create date of the object is acceptable.
    ...
    ...    Parameters:
    ...    - *``scope``*    exec context to work with, *``SUITES``*, *``SUITE``* or *``TEST``*, default is current scope
    ...
    [Arguments]    ${scope}=${SCOPE}
    IF    $scope
        ${result}    Pgsql Query    SELECT current_timestamp
        Should Not Be Empty    ${result}    Unable to get timestamp from the database
        ${${scope.upper()}_CONTEXT.audit_info.timestamp.end_date}    Set Variable    ${result}[0][0]
    END

Set Event Audit Info User
    [Documentation]
    ...    Sets operation user
    ...
    ...    Operation user is used by other keywords
    ...    to determine if the object is created by expected user.
    ...
    ...    Parameters:
    ...    - *``user_name``*    user name that is an author of the operation, default *``api``*
    ...    - *``scope``*    exec context to work with, *``SUITES``*, *``SUITE``* or *``TEST``*, default is current scope
    ...
    [Arguments]    ${user_name}=api    ${scope}=${SCOPE}
    IF    $scope
        ${${scope.upper()}_CONTEXT.audit_info.user}    Set Variable    ${user_name}
    END

Event Audit Start
    [Documentation]
    ...    Sets operation start date/time and user
    ...
    ...    Parameters:
    ...    - *``user_name``*    user name that is an author of the operation, default *``api``*
    ...    - *``scope``*    exec context to work with, *``SUITES``*, *``SUITE``* or *``TEST``*, default is current scope
    ...
    [Arguments]    ${user_name}=api    ${scope}=${SCOPE}
    Set Event Audit Info User    ${user_name}    ${scope}
    Set Event Audit Info Start Date    ${scope}

Event Audit End
    [Documentation]
    ...    Sets operation end date/time
    ...
    ...    Parameters:
    ...    - *``scope``*    exec context to work with, *``SUITES``*, *``SUITE``* or *``TEST``*, default is current scope
    ...
    [Arguments]    ${scope}=${SCOPE}
    Set Event Audit Info End Date    ${scope}
