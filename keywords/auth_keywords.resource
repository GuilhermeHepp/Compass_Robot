*** Settings ***
Resource    common_keywords.resource
Library     RequestsLibrary

*** Variables ***
${AUTH_ENDPOINT}    /auth

*** Keywords ***
Generate Authentication Token
    [Documentation]    Generate authentication token for API access
    [Arguments]    ${username}=admin    ${password}=password123
    
    ${auth_payload}=    Create Dictionary
    ...    username=${username}
    ...    password=${password}
    
    ${response}=    POST On Session
    ...    api_session
    ...    ${AUTH_ENDPOINT}
    ...    json=${auth_payload}
    ...    expected_status=200
    
    Log Response Details    ${response}
    
    ${token}=    Get Value From Json    ${response.json()}    $.token
    ${token}=    Get From List    ${token}    0
    
    Set Suite Variable    ${AUTH_TOKEN}    ${token}
    RETURN    ${token}

Create Auth Headers
    [Documentation]    Create headers with authentication token
    [Arguments]    ${token}=${AUTH_TOKEN}
    ${headers}=    Create Dictionary    Cookie=token=${token}
    RETURN    ${headers}