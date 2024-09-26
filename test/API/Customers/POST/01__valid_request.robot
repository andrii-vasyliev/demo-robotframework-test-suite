*** Settings ***
Documentation       API Create Customer valid requests test cases
Metadata            https://company-jira.atlassian.com/browse/original-requirement
Metadata            https://company-jira.atlassian.com/browse/change-request

Resource            ../../../../res/project_settings.resource
Resource            ../res/customers_helper.robot

Suite Setup         Basic Suite Setup
Suite Teardown      Basic Suite Teardown
Test Setup          Basic Test Setup
Test Teardown       Basic Test Teardown


*** Test Cases ***
Create customer with valid name and no email
    [Documentation]    Create customer with valid name and no email.
    ...
    ...    - Use different locales includimg non-western.
    ...
    [Template]    Create Customer Valid Request
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.EN) }}
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.BG) }}
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.JP) }}

Create customer with valid name and email
    [Documentation]    Create customer with valid name and email.
    ...
    ...    - Use localized domain names in email.
    ...
    [Template]    Create Customer Valid Request
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.EN) }}
    ...    email=${{ FakeItLibrary.FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.EN) }}
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.BG) }}
    ...    email=${{ FakeItLibrary.FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.BG) }}

Create customer with valid name extra cases
    [Documentation]    Create customer with valid name extra cases:
    ...
    ...    - Characters ``\/.'_&,-+@`` are allowed in the customer name
    ...    - Leading/trailing space characters are trimmed
    ...    - Leading/trailing new line characters are trimmed
    ...    - Leading/trailing tabulation characters are trimmed
    ...    - Name of a maximum allowed length (256 characters max after trim)
    ...
    [Template]    Create Customer Valid Request
    name=\/.'${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}_&,-+@
    name=${SPACE}${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}${SPACE*3}
    name=${{ '\r\n' + FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) + '\n' }}
    name=${{ '\t' + FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) + '\t\t' }}
    name=${SPACE}${{ FakeItLibrary.FakeItLibrary.fake_string(256) }}${SPACE*3}

Create customer with valid email extra cases
    [Documentation]    Create customer with valid email extra cases:
    ...
    ...    - Characters ``a-zA-Z0-9`` are allowed in the local- and domain- parts
    ...    - Printable characters ``!#$%&'*+-/=?^_`{|}~`` are allowed in the local-part
    ...    - Classic shortest email possible is allowed
    ...    - Single character top domain is also accepted
    ...    - Local-part up to 64 characters is allowed
    ...    - Domain-part up to 252 characters is allowed
    ...    - Angle brackets and domain-part up to 252 characters is allowed
    ...    - Angle brackets, longest possible local-part (64 characters), longest possible domain-part (189 characters) is allowed
    ...    - Leading/trailing space characters are trimmed
    ...    - Leading/trailing new line characters are trimmed
    ...    - Leading/trailing tab characters are trimmed
    ...
    [Template]    Create Customer Valid Request
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=a-zA-Z0-9@a-zA-Z0-9.eu
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=!#$%&'*+-/=?^_`{|}~@a-zA-Z0-9.eu
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=a@a.eu
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=${{ FakeItLibrary.FakeItLibrary.fake_string() }}@co.u
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=${{ FakeItLibrary.FakeItLibrary.fake_string(64) }}@a.eu
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=a@${{ FakeItLibrary.FakeItLibrary.fake_domain_name(252) }}
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=<a@${{ FakeItLibrary.FakeItLibrary.fake_domain_name(252) }}>
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=<${{ FakeItLibrary.FakeItLibrary.fake_string(64) }}@${{ FakeItLibrary.FakeItLibrary.fake_domain_name(189) }}>
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=${SPACE*2}${{ FakeItLibrary.FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.PL) }}${SPACE}
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=${{ '\t\t' + FakeItLibrary.FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.PL) + '\t' }}
    name=${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ...    email=${{ '\n' + FakeItLibrary.FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.PL) + '\r\n' }}

Create customer customer uniqueness
    [Documentation]    Create customer customer uniqueness:
    ...
    ...    - Customer with unique name and email is accepted
    ...    - Customer with not unique name but no email is accepted
    ...    - Customer with not unique name but unique email is accepted
    ...    - Customer with unique name but not unique email is accepted
    ...
    [Template]    Create Customer Valid Request
    [Setup]    Setup Uniqueness Case
    name=${name1}    email=${email1}
    name=${name1}
    name=${name1}    email=${email2}
    name=${name2}    email=${email1}


*** Keywords ***
Setup Uniqueness Case
    [Documentation]    Performs basic test setup and prepares name and email variables to use in the test case.
    Basic Test Setup
    ${name1}    Set Variable    ${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ${name2}    Set Variable    ${{ FakeItLibrary.FakeItLibrary.fake_customer_name(FakeItLibrary.Locales.PL) }}
    ${email1}    Set Variable    ${{ FakeItLibrary.FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.PL) }}
    ${email2}    Set Variable    ${{ FakeItLibrary.FakeItLibrary.fake_customer_email(FakeItLibrary.Locales.PL) }}
    VAR    ${name1}    ${name1}    scope=${TEST}
    VAR    ${name2}    ${name2}    scope=${TEST}
    VAR    ${email1}    ${email1}    scope=${TEST}
    VAR    ${email2}    ${email2}    scope=${TEST}
