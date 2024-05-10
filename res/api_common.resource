*** Settings ***
Documentation       REST API basic keywords:
...                 - ``Setup API Session``    Creates an HTTP Session for the API
...                 - ``Validate API Response Template``    Template for the API response validation keywords
...                 - ``Validate API Error Response``    Validates given API error response
...

Library             RequestsLibrary
Resource            project_settings.resource
Variables           api_common_jsd.py


*** Keywords ***
Setup API Session
    [Documentation]
    ...    Creates an HTTP Session for the API
    ...
    ${api}    Get Variable Value    ${API}
    Should Be True
    ...    $api and isinstance($api, dict) and $api.get('url', None)
    ...    API url is not defined or invalid for the environment "${ENV_NAME}"
    ${headers}    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    Create Session    API    ${api}[url]${api.get('uri', '')}    ${headers}

Validate API Response Template
    [Documentation]
    ...    Template for the API response validation keywords.
    ...    Validates given API response:
    ...    - response headers content type
    ...    - response HTTP status code
    ...    - response body schema
    ...
    ...    Parameters:
    ...    - ``response``    response to be validated
    ...    - ``json_schema``    json schema for response validation
    ...    - ``content_type``    expected content type in the response headers, default "application/json"
    ...    - ``status_code``    expected response status code, default 200
    ...
    [Arguments]    ${response}    ${json_schema}    ${content_type}=application/json    ${status_code}=${200}
    Dictionary Should Contain Item
    ...    ${response.headers}
    ...    Content-Type
    ...    ${content_type}
    ...    Response headers do not contain JSON content type
    Validate Json By Schema    ${response.json()}    ${json_schema}
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    ${status_code}
    ...    Incorrect API response code

Validate API Error Response
    [Documentation]
    ...    Validates given API error response:
    ...    - response headers content type
    ...    - response HTTP status code
    ...    - response body schema
    ...
    ...    Parameters:
    ...    - ``response``    response to be validated
    ...    - ``status_code``    expected response status code
    ...
    [Arguments]    ${response}    ${expected_status}
    Validate API Response Template
    ...    ${response}
    ...    ${JSD_API_ERROR}
    ...    application/json
    ...    ${expected_status}
