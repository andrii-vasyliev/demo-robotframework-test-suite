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
    IF    $${SUITE}_CONTEXT    Log    ${${SUITE}_CONTEXT}
    IF    $${TEST}_CONTEXT
        Set Operation Start
        Log    ${${TEST}_CONTEXT}
    END
    Log Variables

Check Init 2
    IF    $${SUITE}_CONTEXT    Log    ${${SUITE}_CONTEXT}
    IF    $${TEST}_CONTEXT
        Set Operation Start
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


*** Keywords ***
Setup Suite
    Basic Suite Setup
    Set Operation Start
