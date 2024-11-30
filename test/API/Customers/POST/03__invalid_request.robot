*** Settings ***
Documentation       API Create Customer wrong requests test cases
Metadata            https://company-jira.atlassian.com/browse/original-requirement
Metadata            https://company-jira.atlassian.com/browse/change-request

Resource            ../../../../res/project_settings.resource
Resource            ../res/customers_helper.robot

Test Setup          Basic Test Setup
Test Teardown       Basic Test Teardown


*** Variables ***
${XML_BODY}                 <?xml version="1.0" encoding="UTF-8"?><name>John Smith</name><email>j@s.com</email>
${NOT_JSON_BODY}            {"name": "John Wick" "email": "john_wick@bang-bang.laundry"}
${JSON_LIST}                {"customers": [{"name": "Jason Statham", "email": "dad.jokes@best.memes"},
...                         {"name": "Agent Smith", "email": "elrond@rivendell.me"}]}
&{WRONG_JSON_BODY}          itemid=123456    quantity=1
&{JSON_BODY_EXTRA}          name=John Wick    email=john_wick@bang-bang.laundry    id=123456
&{JSON_BODY}                name=John Wick    email=john_wick@bang-bang.laundry
&{XML_CONTENT_HEADERS}      Content-Type=application/xml
&{TEXT_ACCEPT_HEADERS}      Accept=text/plain


*** Test Cases ***
Create Customer with a wrong body or MIME type
    [Documentation]    Create Customer with a wrong body or MIME type
    ...
    ...    - Request with XML body and JSON Content-Type headers is rejected
    ...    - Request with String body and JSON Content-Type headers is rejected
    ...    - Request without body is rejected
    ...    - Request with empty body is rejected
    ...    - Request with wrong JSON body is rejected
    ...    - Request with extra data is rejected
    ...    - Request with correct JSON body but wrong Content-Type headers is rejected
    ...    - Request with XML body and XML Content-Type headers is rejected
    ...    - Request with correct JSON body but wrong Accept headers is rejected
    ...
    [Template]    Create Customer Wrong Body Or Mimetype
    ${422}    JSON decode error    ${XML_BODY}
    ${422}    JSON decode error    ${NOT_JSON_BODY}
    ${422}    Field required    ${None}
    ${422}    Field required    ${EMPTY}
    ${422}    Field required    ${JSON_LIST}
    ${422}    Field required    ${WRONG_JSON_BODY}
    ${422}    Extra inputs are not permitted    ${JSON_BODY_EXTRA}
    ${422}    Input should be a valid dictionary or object    ${JSON_BODY}    headers=${XML_CONTENT_HEADERS}
    ${422}    Input should be a valid dictionary or object    ${XML_BODY}    headers=${XML_CONTENT_HEADERS}
    ${406}    This endpoint only supports application/json responses    ${JSON_BODY}    headers=${TEXT_ACCEPT_HEADERS}
