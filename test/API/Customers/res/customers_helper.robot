*** Settings ***
Documentation       API Customer template keywords

Resource            ../../../../res/project_settings.resource


*** Keywords ***
Create Customer Valid Request
    [Documentation]
    ...    Sends POST request to API Customers that is expected to be valid.
    ...
    ...    Validates received response:
    ...    - response headers content type
    ...    - response status code
    ...    - response body schema
    ...    - response body content against expected entity
    ...
    ...    Parameters:
    ...    - ``&args``    named arguments that represent key/value pairs of the Create Customer body
    ...
    [Arguments]    &{args}
    ${body}    Create Dictionary    &{args}
    Set Operation User
    Set Operation Start
    ${response}    Do POST    API    customers    ${body}
    Set Operation End
    Validate Create Customer Success Response    ${response}
    ${c}    Define Customer
    ...    ${response.json()}[id]
    ...    ${args.get('name', None)}
    ...    ${args.get('email', None)}
    ...    scope=${SCOPE}
    Dictionaries Should Be Equal    ${c.json}    ${response.json()}    API response is not as expected
    Validate Customers    ${c}

Get Customer By Id Valid Request
    [Documentation]
    ...    Send GET request to API Customers to get particular customer by Id.
    ...
    ...    Validates received response:
    ...    - response headers content type
    ...    - response status code
    ...    - response body schema
    ...    - response body content against expected entity
    ...
    ...    Parameters:
    ...    - ``customer``    customer entity to get
    ...
    [Arguments]    ${customer}
    ${response}    GET On Session    API    customers/${customer.id}
    Validate Get Customer Success Response    ${response}
    Dictionaries Should Be Equal    ${customer.json}    ${response.json()}    API response is not as expected

Get Customers By Parameters Valid Request
    [Documentation]
    ...    Send GET request to API Customers to get customers by name and/or email.
    ...
    ...    Validates received response:
    ...    - response headers content type
    ...    - response status code
    ...    - response body schema
    ...    - response body content against expected entity
    ...
    ...    Parameters:
    ...    - ``name``    customer name
    ...    - ``email``    customer email
    ...    - ``customers``    expected customer entities to get
    ...
    [Arguments]    ${name}=${None}    ${email}=${None}    @{customers}    &{custom_params}
    ${params}    Combine Request Parameters    name=${name}    email=${email}    &{custom_params}
    ${response}    GET On Session    API    customers    ${params}
    Validate Get Customers Success Response    ${response}
    ${customers_json}    Evaluate    {"customers": sorted([c.json for c in $customers], key=lambda x: x["id"])}
    ${sorted_response}    Evaluate    {key: sorted(value, key=lambda x: x["id"]) if isinstance(value, list) else value for key,value in $response.json().items()}
    Dictionaries Should Be Equal    ${customers_json}    ${sorted_response}    API response is not as expected

Create Customer Invalid Request
    [Documentation]
    ...    Sends POST request to API Customers that is expected to be invalid.
    ...
    ...    Validates received response:
    ...    - response headers content type
    ...    - response status code
    ...    - response body schema
    ...    - response body content against expected error
    ...
    ...    Parameters:
    ...    - ``expected_status``    expected response HTTP status code
    ...    - ``msg``    expected error message
    ...    - ``&args``    named arguments that represent key/value pairs of the Create Customer body
    ...
    [Arguments]    ${expected_status}    ${msg}    &{args}
    ${body}    Create Dictionary    &{args}
    ${response}    Do POST    API    customers    ${body}    expected_status=any
    Validate API Error Response    ${response}    ${expected_status}
    Should Contain    ${response.json()}[detail][0][msg]    ${msg}    Incorrect Create Customer error message

Create Customer Wrong Body Or Mimetype
    [Documentation]
    ...    Sends POST request to API Customers with wrong body mimetype.
    ...
    ...    Validates received response:
    ...    - response headers content type
    ...    - response status code
    ...    - response body schema
    ...    - response body content against expected error
    ...
    ...    Parameters:
    ...    - ``expected_status``    expected response HTTP status code
    ...    - ``msg``    expected error message
    ...    - ``body``    payload to send
    ...    - ``&args``    named arguments to be passed to ``Post On Session``
    ...
    [Arguments]    ${expected_status}    ${msg}    ${body}    &{args}
    ${response}    Do POST    API    customers    ${body}    expected_status=any    &{args}
    Validate API Error Response    ${response}    ${expected_status}
    Should Contain    ${response.json()}[detail][0][msg]    ${msg}    Incorrect Create Customer error message

Get Customer By Id Invalid Request
    [Documentation]
    ...    Sends Get request to API Customers that is expected to be invalid.
    ...
    ...    Validates received response:
    ...    - response headers content type
    ...    - response status code
    ...    - response body schema
    ...    - response body content against expected error
    ...
    ...    Parameters:
    ...    - ``expected_status``    expected response HTTP status code
    ...    - ``msg``    expected error message
    ...    - ``customer_id``    id of the customer to Get
    ...
    [Arguments]    ${expected_status}    ${msg}    ${customer_id}
    ${response}    GET On Session    API    customers/${customer_id}    expected_status=any
    Validate API Error Response    ${response}    ${expected_status}
    Should Contain    ${response.json()}[detail][0][msg]    ${msg}    Incorrect Get Customer error message

Get Customers By Parameters Invalid Request
    [Documentation]
    ...    Send GET request to API Customers to get customers by name and/or email.
    ...
    ...    Validates received response:
    ...    - response headers content type
    ...    - response status code
    ...    - response body schema
    ...    - response body content against expected entity
    ...
    ...    Parameters:
    ...    - ``expected_status``    expected response HTTP status code
    ...    - ``msg``    expected error message
    ...    - ``&args``    named arguments to be passed to ``Get On Session``
    ...
    [Arguments]    ${expected_status}    ${msg}    &{args}
    ${params}    Combine Request Parameters    &{args}
    ${response}    GET On Session    API    customers    ${params}    expected_status=any
    Validate API Error Response    ${response}    ${expected_status}
    Should Contain    ${response.json()}[detail][0][msg]    ${msg}    Incorrect Get Customers error message
