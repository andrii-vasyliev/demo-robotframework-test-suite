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
    name=John Reacher
    name=Grzegorz Brzęczyszczykiewicz
    name=d'Artagnan

Create customer with valid name and email
    [Template]    Create Customer Valid Request
    name=John Wick    email=john_wick@bang-bang.laundry
    name=Grzegorz Brzęczyszczykiewicz    email=brzęczyszczykiewicz@łękołody.ąę

Create customer with valid name extra cases
    [Template]    Create Customer Valid Request
    name=Mr. \\Quick-Fix/_&,
    name=${SPACE}X Starship dives Into${SPACE*3}
    name=${{ '\n\nLFs in the name\n' }}
    name=${{ '\tTabs in the name\t\t' }}

Create customer with valid email extra cases
    [Template]    Create Customer Valid Request
    name=Email Allowed Chars    email=-+._aZ0@zA-9.eu
    name=Email Minimum Chars    email=a@a.eu
    name=Email with spaces    email=${SPACE*2}validemail@x.com${SPACE}
    name=Email with tabs    email=${{ '\t\tvalidemail@x.com\t' }}
    name=Email with LFs    email=${{ '\nvalidemail@x.com\n\n' }}
    # Email is not valid, but this is how default pydantic validation works
    name=John Doe    email=invalidemail@com.c

Create customer customer uniqueness
    [Template]    Create Customer Valid Request
    name=Same Name Diff Emails    email=someone@email.me
    name=Same Name Diff Emails
    name=Same Name Diff Emails    email=someone@dont.email.me
    name=Diff Name Same Email    email=someone@email.me
