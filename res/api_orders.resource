*** Settings ***
Documentation       API Orders keywords:
...                 - ``Validate Create Order Success Response``    Validates given successful API Create Order response
...

Resource            project_settings.resource
Variables           api_orders_jsd.py


*** Keywords ***
Validate Create Order Success Response
    [Documentation]
    ...    Validates given successful API Create Order response:
    ...    - response headers content type
    ...    - response HTTP status code
    ...    - response body schema
    ...
    ...    Parameters:
    ...    - ``response``    response to be validated
    ...
    [Arguments]    ${response}
    Validate API Response Template    ${response}    ${JSD_CREATE_ORDER_SUCCESS}    application/json    ${201}
