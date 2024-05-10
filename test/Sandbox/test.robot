*** Settings ***
Documentation       Sandbox for approaches testing and proof of concept

Resource            ../res/project_settings.resource

Suite Setup         Setup Suite
Suite Teardown      Basic Suite Teardown
Test Setup          Basic Test Setup
Test Teardown       Basic Test Teardown


*** Test Cases ***
DB Query
    ${stmnt}    Set Variable    select CURRENT_DATE
    ${txt}    Set Variable    it's not a valid query
    ${result}    Pgsql Query    ${stmnt}
    Log    ${result}
    ${result}    Pgsql Query    ${txt}

    Log    ${result}

Check Init 1
    IF    $SUITE_CONTEXT    Log    ${SUITE_CONTEXT}
    IF    $TEST_CONTEXT
        Set Operation Start
        Log    ${TEST_CONTEXT}
    END

Check Init 2
    IF    $SUITE_CONTEXT    Log    ${SUITE_CONTEXT}
    IF    $TEST_CONTEXT
        Set Operation Start
        Log    ${TEST_CONTEXT}
    END

PG List
    Setup API Session
    ${c1}    API Create Customer
    ${c2}    API Create Customer
    ${result}    PG Get Customers By Ids    ${c1.id}    ${c2.id}
    ${expected}    Create List    ${c1.row}    ${c2.row}
    Lists Should Be Equal    ${expected}    ${result}


*** Keywords ***
Setup Suite
    Basic Suite Setup
    Set Operation Start
