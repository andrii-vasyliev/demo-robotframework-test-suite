*** Settings ***
Documentation       REST API basic keywords:
...                 - *``Setup API Session``*    Creates an HTTP Session for the API
...                 - *``Check Service Health``*    Queries health endpoint of the provided service.
...                 Check is skipped if health endpoint is not configured.
...                 - *``Check Service Availability``*    Queries ping endpoint of the provided service.
...                 Check is skipped if ping endpoint is not configured.
...                 - *``Validate API Response Template``*    Template for the API response validation keywords
...                 - *``Validate API Error Response``*    Validates given API error response
...

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
    ...    API configuration is not defined or invalid for the environment "${ENV_NAME}"
    Check Service Health    ${api}
    Create Session    API    ${api}[url]${api.get('uri', '')}    headers=${DEFAULT_API_HEADERS}

Check Service Health
    [Documentation]
    ...    Queries health endpoint of the provided service. Check is skipped if health endpoint is not configured.
    ...
    ...    Parameters:
    ...    - *``svc_conf``*    service configuration dictionary as it is described in the environment configuration
    ...
    [Arguments]    ${svc_conf}
    IF    $svc_conf.get('health', None)
        ${status}    ${response}    Run Keyword And Ignore Error
        ...    GET
        ...    ${svc_conf}[url]${svc_conf}[health]
        ...    headers=${DEFAULT_API_HEADERS}
        Should Be True    $status == "PASS"    Service is not accessible:\n${response}
        Validate API Response Template    ${response}    ${JSD_API_HEALTH}
        Should Be Equal As Strings    ${response.json()}[status]    UP    Service is not ready
    END

Check Service Availability
    [Documentation]
    ...    Queries ping endpoint of the provided service. Check is skipped if ping endpoint is not configured.
    ...
    ...    Parameters:
    ...    - *``svc_conf``*    service configuration dictionary as it is described in the environment configuration
    ...
    [Arguments]    ${svc_conf}
    IF    $svc_conf.get('ping', None)
        ${status}    ${response}    Run Keyword And Ignore Error
        ...    GET
        ...    ${svc_conf}[url]${svc_conf}[ping]
        ...    headers=${DEFAULT_API_HEADERS}
        Should Be True    $status == "PASS"    Service is not accessible:\n${response}
        Should Be Equal As Integers
        ...    ${response.status_code}
        ...    ${204}
        ...    HTTP status code "${response.status_code}" received when "${204}" is expected
        Should Be Empty    ${response.text}    Unexpected response body returned:\n${response.text}
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
    ...    - *``response``*    response to be validated
    ...    - *``json_schema``*    json schema for response validation
    ...    - *``content_type``*    expected Content-Type in the response headers, default "application/json"
    ...    - *``status_code``*    expected response HTTP status code, default 200
    ...
    [Arguments]    ${response}    ${json_schema}    ${content_type}=application/json    ${status_code}=${200}
    Dictionary Should Contain Item
    ...    ${response.headers}
    ...    Content-Type
    ...    ${content_type}
    ...    Response header "Content-Type" does not contain "${content_type}"
    Validate Json By Schema    ${response.json()}    ${json_schema}
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    ${status_code}
    ...    HTTP status code "${response.status_code}" received when "${status_code}" is expected

Validate API Error Response
    [Documentation]
    ...    Validates given API error response:
    ...    - response headers content type
    ...    - response HTTP status code
    ...    - response body schema
    ...
    ...    Parameters:
    ...    - *``response``*    response to be validated
    ...    - *``status_code``*    expected response status code
    ...
    [Arguments]    ${response}    ${status_code}
    Validate API Response Template
    ...    ${response}
    ...    ${JSD_API_ERROR}
    ...    application/json
    ...    ${status_code}
