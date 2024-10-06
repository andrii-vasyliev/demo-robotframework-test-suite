*** Settings ***
Documentation       REST API basic keywords:
...                 - ``Setup API Session``    Creates an HTTP Session for the API
...                 - ``Check Service Health``    Queries health endpoint of the provided service.
...                 Check is skipped if health endpoint is not configured.
...                 - ``Validate API Response Template``    Template for the API response validation keywords
...                 - ``Validate API Error Response``    Validates given API error response
...

Library             RequestsLibrary
Resource            project_settings.resource
Variables           api_common_jsd.py


*** Variables ***
&{DEFAULT_API_HEADERS}      Content-Type=application/json    Accept=application/json


*** Keywords ***
Setup API Session
    [Documentation]
    ...    Creates an HTTP Session for the API
    ...
    ${api}    Get Variable Value    ${API}
    Should Be True
    ...    $api and isinstance($api, dict) and $api.get('url', None)
    ...    API url is not defined or invalid for the environment "${ENV_NAME}"
    Check Service Health    ${api}
    Create Session    API    ${api}[url]${api.get('uri', '')}    headers=${DEFAULT_API_HEADERS}

Check Service Health
    [Documentation]
    ...    Queries health endpoint of the provided service. Check is skipped if health endpoint is not configured.
    ...
    ...    Parameters:
    ...    - `api_env_dict`    service configuration dictionary as it is described in the environment configuration
    ...
    [Arguments]    ${api_env_dict}
    IF    $api_env_dict.get('health', None)
        ${status}    ${response}    Run Keyword And Ignore Error
        ...    GET
        ...    ${api_env_dict}[url]${api_env_dict}[health]
        ...    headers=${DEFAULT_API_HEADERS}
        Should Be True    $status == "PASS"    API is not accessible:\n${response}
        Validate Json By Schema    ${response.json()}    ${JSD_API_HEALTH}
        Should Be Equal As Strings    ${response.json()}[status]    UP    API is not ready
    END

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
    [Arguments]    ${response}    ${status_code}
    Validate API Response Template
    ...    ${response}
    ...    ${JSD_API_ERROR}
    ...    application/json
    ...    ${status_code}
