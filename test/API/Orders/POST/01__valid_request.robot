*** Settings ***
Documentation       Create Order valid requests

Resource            ../../../../res/project_settings.resource

Test Setup          Setup Create Order Test
Test Teardown       Basic Test Teardown


*** Variables ***
&{MB}               item_id=${${GLOBAL}_CONTEXT.catalog[0].id}    quantity=${1}
&{MEM}              item_id=${${GLOBAL}_CONTEXT.catalog[1].id}    quantity=${2}
&{CF}               item_id=${${GLOBAL}_CONTEXT.catalog[2].id}    quantity=${1}
&{PROC}             item_id=${${GLOBAL}_CONTEXT.catalog[3].id}    quantity=${1}
@{ONE_ITEM}         ${MB}
@{FEW_ITEMS}        ${MB}    ${MEM}    ${PROC}
@{SAME_ITEMS}       ${CF}    ${CF}
@{MIX_ITEMS}        ${MB}    ${MEM}    ${CF}    ${MEM}    ${PROC}


*** Test Cases ***
Create order
    [Template]    Create Order Valid Request
    customer_id=${${TEST}_CONTEXT.customers[0].id}    items=${ONE_ITEM}
    customer_id=${${TEST}_CONTEXT.customers[0].id}    items=${FEW_ITEMS}
    customer_id=${${TEST}_CONTEXT.customers[0].id}    items=${SAME_ITEMS}
    customer_id=${${TEST}_CONTEXT.customers[0].id}    items=${MIX_ITEMS}


*** Keywords ***
Setup Create Order Test
    Basic Test Setup
    API Create Customer

Create Order Valid Request
    [Documentation]    Sends POST request to API Create Order that is expected to be valid.
    ...
    ...    Validates received response:
    ...    - response status code
    ...    - response body structure
    ...    - response body content against expected entity
    ...
    ...    Parameters:
    ...    - _*&args*_    named arguments that represent key/value pairs of the Create Order body
    ...
    [Arguments]    &{args}
    ${body}    Create Dictionary    &{args}
    Event Audit Start
    ${response}    Do POST    API    orders    ${body}
    Event Audit End
    Validate Create Order Success Response    ${response}
    ${o}    Define Order    ${args.get('items', None)}
    Populate Order Data From Response    ${o}    ${response.json()}
    Dictionaries Should Be Equal    ${o.json()}    ${response.json()}
