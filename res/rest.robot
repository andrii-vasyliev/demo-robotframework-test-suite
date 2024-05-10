*** Settings ***
Documentation       REST API basic keywords:
...                 - ``Combine Request Parameters``    Combines the given parameters into a query string.
...                 - ``Do POST``    Sends a POST request on a previously created HTTP Session.
...                 Refer to ``POST On Session`` documentation for the list of supported arguments.
...

Resource            project_settings.resource
Variables           api_common_jsd.py


*** Keywords ***
Combine Request Parameters
    [Documentation]
    ...    Combines the given parameters into a query string.
    ...
    [Arguments]    &{args}
    ${params}    Evaluate
    ...    urllib.parse.urlencode({k: v for k, v in $args.items() if v is not None})
    ...    modules=urllib.parse
    RETURN    ${params}

Do POST
    [Documentation]
    ...    Sends a POST request on a previously created HTTP Session.
    ...
    ...    Keyword is a wrapper for the ``POST On Session``.
    ...    Refer to ``POST On Session`` documentation for the list of supported arguments.
    ...
    [Arguments]    ${session}    ${url}    ${body}=${None}    &{args}
    IF    isinstance($body, dict)
        Set To Dictionary    ${args}    json=${body}
    ELSE
        Set To Dictionary    ${args}    data=${body}
    END
    ${response}    POST On Session    ${session}    ${url}    &{args}
    RETURN    ${response}
