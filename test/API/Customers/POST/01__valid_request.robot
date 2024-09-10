*** Settings ***
Documentation       API Create Customer valid requests test cases

Resource            ../../../../res/project_settings.resource
Resource            ../res/customers_helper.robot

Suite Setup         Basic Suite Setup
Suite Teardown      Basic Suite Teardown
Test Setup          Basic Test Setup
Test Teardown       Basic Test Teardown


*** Test Cases ***
Create customer with valid name and no email
    [Template]    Create Customer Valid Request
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.EN) }}
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.RU) }}
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.JP) }}

Create customer with valid name and email
    [Template]    Create Customer Valid Request
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.EN) }}
    ...    email=${{ FakeItLibrary.FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.EN) }}
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.RU) }}
    ...    email=${{ FakeItLibrary.FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.RU) }}

Create customer with valid name extra cases
    [Template]    Create Customer Valid Request
    name=\/.'${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}_&,-+@
    name=${SPACE}${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}${SPACE*3}
    name=${{ '\n\n' + FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) + '\n' }}
    name=${{ '\t' + FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) + '\t\t' }}

Create customer with valid email extra cases
    [Template]    Create Customer Valid Request
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=-+._aZ0@zA-9.eu
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=a@a.eu
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=${SPACE*2}validemail@x.com${SPACE}
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=${{ '\t\tvalidemail@x.com\t' }}
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=${{ '\nvalidemail@x.com\n\n' }}
    # Email is not valid, but this is how default pydantic validation works
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=invalidemail@com.c

Create customer customer uniqueness
    [Setup]    Setup Uniqueness Case
    [Template]    Create Customer Valid Request
    name=${name1}    email=${email1}
    name=${name1}
    name=${name1}    email=${email2}
    name=${name2}    email=${email1}

*** Keywords ***
Setup Uniqueness Case
    Basic Test Setup
    ${name1}    Set Variable    ${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ${name2}    Set Variable    ${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ${email1}    Set Variable    ${{ FakeItLibrary.FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.PL) }}
    ${email2}    Set Variable    ${{ FakeItLibrary.FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.PL) }}
    VAR    ${name1}    ${name1}    scope=TEST
    VAR    ${name2}    ${name2}    scope=TEST
    VAR    ${email1}    ${email1}    scope=TEST
    VAR    ${email2}    ${email2}    scope=TEST
