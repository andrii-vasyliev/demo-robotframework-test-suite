*** Settings ***
Documentation       API Create Customer wrong requests test cases

Resource            ../../../../res/project_settings.resource
Resource            ../res/customers_helper.robot

Test Setup          Basic Test Setup
Test Teardown       Basic Test Teardown


*** Variables ***
${XML_BODY}                 <?xml version="1.0" encoding="UTF-8"?><name>John Smith</name><email>j@s.com</email>
${NOT_JSON_BODY}            {"name": "John Wick" "email": "john_wick@bang-bang.laundry"}
&{WRONG_JSON_BODY}          itemid=123456    quantity=1
&{JSON_BODY_EXTRA}          name=John Wick    email=john_wick@bang-bang.laundry    id=123456
&{JSON_BODY}                name=John Wick    email=john_wick@bang-bang.laundry
&{XML_CONTENT_HEADERS}      Content-Type=application/xml
&{TEXT_ACCEPT_HEADERS}      Accept=application/text


*** Test Cases ***
Create Customer with a wrong body or mimetype
    [Template]    Create Customer Wrong Body Or Mimetype
    ${422}    JSON decode error    ${XML_BODY}
    ${422}    JSON decode error    ${NOT_JSON_BODY}
    ${422}    Field required    ${None}
    ${422}    Field required    ${EMPTY}
    ${422}    Field required    ${WRONG_JSON_BODY}
    ${422}    Extra inputs are not permitted    ${JSON_BODY_EXTRA}
    ${422}    Input should be a valid dictionary or object    ${JSON_BODY}    headers=${XML_CONTENT_HEADERS}
    ${422}    Input should be a valid dictionary or object    ${XML_BODY}    headers=${XML_CONTENT_HEADERS}
    # Following case is ignored by FastAPI, so do we
    # ${406}    Unsupported response content type    ${JSON_BODY}    headers=${TEXT_ACCEPT_HEADERS}
