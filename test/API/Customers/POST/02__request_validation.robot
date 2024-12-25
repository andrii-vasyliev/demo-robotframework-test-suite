*** Settings ***
Documentation       API Create Customer invalid requests test cases
Metadata            https://company-jira.atlassian.com/browse/original-requirement
Metadata            https://company-jira.atlassian.com/browse/change-request

Resource            ../../../../res/project_settings.resource
Resource            ../res/customers_helper.robot

Test Setup          Basic Test Setup
Test Teardown       Basic Test Teardown


*** Variables ***
${DUPLICATE_NAME_LAST_INVALID}      {"name": "${{ FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.EN) }}",
...                                 "email": "${{ FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.EN) }}",
...                                 "name": "${EMPTY}"}
${DUPLICATE_EMAIL_LAST_INVALID}     {"email": "${{ FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.EN) }}",
...                                 "name": "${{ FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.EN) }}",
...                                 "email": "(),:;<>[\]@com.pl"}


*** Test Cases ***
Create customer name validation
    [Documentation]    Create customer name validation
    ...
    ...    - Request with absent name is rejected
    ...    - Request with absent name but email present is rejected
    ...    - Request with name is null is rejected
    ...    - Request with name is null but valid email is rejected
    ...    - Request with empty name is rejected
    ...    - Request with name is *``space``* is rejected
    ...    - Request with name containig *``new line``* is rejected
    ...    - Request with name containig *``tab``* is rejected
    ...    - Requests with name containig not allowed characters are rejected
    ...
    [Template]    Create Customer Invalid Request
    ${422}    Field required
    ${422}    Field required    email=e@mail.com
    ${422}    Input should be a valid string    name=${None}
    ${422}    Input should be a valid string    name=${None}    email=e@mail.com
    ${422}    cannot be empty    name=${EMPTY}    email=e@mail.com
    ${422}    cannot be empty    name=${SPACE}    email=e@mail.com
    ${422}    must contain only allowed chars    name=${{ 'Some\nName' }}    email=e@mail.com
    ${422}    must contain only allowed chars    name=${{ 'Some\tName' }}    email=e@mail.com
    # Case below should be split by each not allowed character but it's already enough for the demo
    ${422}    must contain only allowed chars    name=();:{}    email=e@mail.com

Create customer email validation
    [Documentation]    Create customer email validation
    ...
    ...    - Request with present but empty email is rejected
    ...    - Requests with various invalid emails are rejected
    ...    - Requests with invalid characters in the Local-part are rejected
    ...    - Request with too long Local-part is rejected
    ...    - Request with too long Domain-part is rejected
    ...    - Request with too long email is rejected
    ...    - Request with too long email with angle brackets is rejected
    ...    - Requests with various exotic emails are rejected
    ...
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
    ${422}    is not a valid email address    name=Invalid Email    email=invalidemail@-com.pl
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
    # Case below should be split by each not allowed character but it's already enough for the demo
    ${422}    is not a valid email address    name=Invalid Character In Local-part
    ...    email="(),:;<>[\]@com.pl
    ${422}    is not a valid email address    name=Local Part Is Too Long
    ...    email=65_characters_user_name_is_not_allowed_abcdefghijklmnopqrstuvwxyz@a.eu
    ${422}    is not a valid email address    name=Domain Part Is Too Long
    ...    email=a@${{ FakeItLibrary.fake_domain_name(253) }}
    ${422}    is not a valid email address    name=Email Is Too Long
    ...    email=${{ FakeItLibrary.fake_string(64) }}@${{ FakeItLibrary.fake_domain_name(190) }}
    ${422}    is not a valid email address    name=Email With Angle Brakets Is Too Long
    ...    email=<${{ FakeItLibrary.fake_string(64) }}@${{ FakeItLibrary.fake_domain_name(190) }}>
    # Default pydantic validaion does not allow exotic emails
    ${422}    is not a valid email address    name=Semi-valid I    email="a-z${SPACE}A-Z"@email.eu
    ${422}    is not a valid email address    name=Semi-valid II    email=".a-z.A-Z"@email.eu
    ${422}    is not a valid email address    name=Semi-valid III    email="a-z..A-Z"@email.eu
    ${422}    is not a valid email address    name=Semi-valid IV    email="a-z.A-Z."@email.eu
    ${422}    is not a valid email address    name=Email Is A Space    email="${SPACE}"@a.eu

Create customer uniqueness validation
    [Documentation]    Create customer uniqueness validation
    ...
    ...    - Duplicate request to create customer with no email is rejected
    ...    - Duplicate request to create customer with email is rejected
    ...
    [Template]    Create Customer Invalid Request
    [Setup]    Setup Uniqueness Validation Case
    ${409}    Customer already exist    name=${${TEST}_CONTEXT.customers[0].name}
    ${409}    Customer already exist    name=${${TEST}_CONTEXT.customers[1].name}    email=${${TEST}_CONTEXT.customers[1].email}

Create customer with duplicate keys validation
    [Documentation]    Create customer with JSON that has duplicate keys:
    ...
    ...    - name is duplicated in the JSON body, last name value is invalid
    ...    - email is duplicated in the JSON body, last email value is invalid
    ...
    [Template]    Create Customer With Duplicate Keys Invalid Request
    ${422}    cannot be empty    ${DUPLICATE_NAME_LAST_INVALID}
    ${422}    is not a valid email address    ${DUPLICATE_EMAIL_LAST_INVALID}


*** Keywords ***
Setup Uniqueness Validation Case
    [Documentation]    Performs basic test setup and creates few customers to use in the test case.
    Basic Test Setup
    API Create Customer    name=${FAKE_IT}
    API Create Customer
