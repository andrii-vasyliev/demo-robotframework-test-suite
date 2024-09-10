*** Settings ***
Documentation       API Create Customer invalid requests test cases

Resource            ../../../../res/project_settings.resource
Resource            ../res/customers_helper.robot

Test Setup          Basic Test Setup
Test Teardown       Basic Test Teardown


*** Test Cases ***
Create customer name validation
    [Template]    Create Customer Invalid Request
    ${422}    Field required
    ${422}    Field required    email=e@mail.com
    ${422}    Input should be a valid string    name=${None}    email=e@mail.com
    ${422}    cannot be empty    name=${EMPTY}    email=e@mail.com
    ${422}    cannot be empty    name=${SPACE}    email=e@mail.com
    ${422}    must contain only allowed chars    name=${{ 'Some\nName' }}    email=e@mail.com
    ${422}    must contain only allowed chars    name=${{ 'Some\tName' }}    email=e@mail.com
    ${422}    must contain only allowed chars    name=();:{}    email=e@mail.com

Create customer email validation
    [Template]    Create Customer Invalid Request
    ${422}    is not a valid email address    name=Invalid Email    email=${EMPTY}
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail.
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail.com
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail.com.pl
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail@
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail@com
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail@com.
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail@com.c+
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail@.
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail@.com
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail@.com.pl
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail@com.pl@com.pl
    ${422}    is not a valid email address    name=Invalid Email    email=@com.pl
    ${422}    is not a valid email address    name=Invalid Email    email="@com.pl
    ${422}    is not a valid email address    name=Invalid Email    email=${SPACE}@com.pl
    ${422}    is not a valid email address    name=Invalid Email    email=i${SPACE}x@com.pl
    ${422}    is not a valid email address    name=Invalid Email    email=i"${SPACE}"x@com.pl
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail@"${SPACE}x".com
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail@"${SPACE}x.com"
    ${422}    is not a valid email address    name=Invalid Email    email="invalidemail@${SPACE}x.com"
    ${422}    is not a valid email address    name=Invalid Email    email=.invalid.email@com.pl
    ${422}    is not a valid email address    name=Invalid Email    email=invalid.email.@com.pl
    ${422}    is not a valid email address    name=Invalid Email    email=invalid..email@com.pl
    ${422}    is not a valid email address    name=User Name Too Long    email=65_characters_user_name_is_not_allowed_abcdefghijklmnopqrstuvwxyz@a.eu
    # Default pydantic validaion does not allow exotic emails
    ${422}    is not a valid email address    name=Email Allowed Chars II    email="-+._${SPACE}zA9"@zA-9.eu
    ${422}    is not a valid email address    name=Email A Space    email="${SPACE}"@a.eu

Create customer uniqueness validation
    [Template]    Create Customer Invalid Request
    [Setup]    Setup Uniqueness Validation Case
    ${409}    Customer already exist    name=${TEST_CONTEXT.customers[0].name}
    ${409}    Customer already exist    name=${TEST_CONTEXT.customers[1].name}    email=${TEST_CONTEXT.customers[1].email}


*** Keywords ***
Setup Uniqueness Validation Case
    Basic Test Setup
    API Create Customer    email=${None}
    API Create Customer
