*** Settings ***
Resource    common_keywords.resource
Resource    ../variables/global_variables.resource
Library     RequestsLibrary

*** Keywords ***
Generate Authentication Token
    [Documentation]    Generate authentication token for API access
    [Arguments]    ${username}=${DEFAULT_USERNAME}    ${password}=${DEFAULT_PASSWORD}
    
    ${auth_payload}=    Create Dictionary
    ...    username=${username}
    ...    password=${password}
    
    FOR    ${attempt}    IN RANGE    3
        ${status}=    Run Keyword And Return Status
        ...    POST On Session    ${API_SESSION}    ${AUTH_ENDPOINT}    json=${auth_payload}    expected_status=200
        IF    ${status}
            ${response}=    POST On Session    ${API_SESSION}    ${AUTH_ENDPOINT}    json=${auth_payload}    expected_status=200
            BREAK
        END
        Sleep    5s
    END
    
    Should Be True    ${status}    Failed to authenticate after 3 attempts
    
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