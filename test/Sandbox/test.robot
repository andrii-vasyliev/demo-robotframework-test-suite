*** Settings ***
Documentation       Sandbox for approaches testing and proof of concept

Resource            ../../res/project_settings.resource

# Suite Setup    Setup Suite
# Suite Teardown    Basic Suite Teardown
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
    IF    $${SUITE}_CONTEXT    Log    ${${SUITE}_CONTEXT}
    IF    $${TEST}_CONTEXT
        Set Event Audit Info Start Date
        Log    ${${TEST}_CONTEXT}
    END
    Log Variables

Check Init 2
    IF    $${SUITE}_CONTEXT    Log    ${${SUITE}_CONTEXT}
    IF    $${TEST}_CONTEXT
        Set Event Audit Info Start Date
        Log    ${${TEST}_CONTEXT}
    END

PG List
    Setup API Session
    ${c1}    API Create Customer
    ${c2}    API Create Customer
    ${result}    PG Get Customers By Ids    ${c1.id}    ${c2.id}
    ${expected}    Create List    ${c1.row}    ${c2.row}
    Lists Should Be Equal    ${expected}    ${result}

Faker
    ${name}    Fake Customer Name
    ${name}    Fake Customer Name    PL
    ${name}    Fake Customer Name    BG
    ${name}    Fake Customer Name    JP
    ${email}    Fake Customer Email    PL
    ${email}    Fake Customer Email    BG    .
    ${email}    Fake Customer Email    BG    ${EMPTY}
    Log    ${{ FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.EN) }}
    Log    ${{ FakeItLibrary.fake_string() }}
    Log    ${{ FakeItLibrary.fake_string(25) }}
    Log    ${{ FakeItLibrary.fake_domain_name(10) }}
    Log    ${{ FakeItLibrary.fake_domain_name(15) }}
    Log    ${{ FakeItLibrary.fake_domain_name(255) }}

No scope
    [Documentation]    Suite or Suites context must not be initialized to check this case properly
    ...    Comment ``Suite Setup/Teardown`` in the ``Settings`` section before execution
    [Setup]    No Operation
    Setup API Session
    ${c}    API Create Customer
    Log Many    ${SUITES_CONTEXT}    ${SUITE_CONTEXT}    ${TEST_CONTEXT}
    [Teardown]    No Operation

Ping
    Check Service Availability    ${API}

Create Customer
    Setup API Session
    ${c0}    API Create Customer
    ${c1}    API Create Customer    name=${{ FakeItLibrary.fake_customer_name() }}
    ${c2}    API Create Customer
    ...    name=${{ FakeItLibrary.fake_customer_name() }}
    ...    email=${{ FakeItLibrary.fake_customer_email() }}
    ${c3}    API Create Customer    name=${FAKE_IT}
    ${c5}    API Create Customer    name=${FAKE_IT}    email=${EMPTY}
    ${c6}    API Create Customer    name=${FAKE_IT}    email=${None}
    ${c7}    API Create Customer    name=${FAKE_IT}    email=${FAKE_IT}
    Validate Test Data


*** Keywords ***
Setup Suite
    Basic Suite Setup
    Set Event Audit Info Start Date
