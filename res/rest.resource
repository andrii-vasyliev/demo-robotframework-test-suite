*** Settings ***
Documentation       REST API basic keywords:
...                 - *``Do POST``*    Sends a *``POST``* request on a previously created HTTP Session.
...                 Refer to *``POST On Session``* documentation for the list of supported arguments.
...

Resource            project_settings.resource


*** Keywords ***
Do POST
    [Documentation]
    ...    Sends a *``POST``* request on a previously created HTTP Session.
    ...
    ...    Keyword is a wrapper for the *``POST On Session``*.
    ...    Refer to *``POST On Session``* documentation for the list of supported arguments.
    ...
    [Arguments]    ${session}    ${url}    ${body}=${None}    &{args}
    IF    isinstance($body, dict)
        Set To Dictionary    ${args}    json=${body}
    ELSE
        Set To Dictionary    ${args}    data=${body}
    END
    ${response}    POST On Session    ${session}    ${url}    &{args}
    RETURN    ${response}
