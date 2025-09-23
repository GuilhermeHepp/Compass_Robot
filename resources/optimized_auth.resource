*** Settings ***
Documentation    Optimized authentication keywords with best practices
Library          RequestsLibrary
Library          Collections
Resource        ../keywords/common_keywords.resource

*** Variables ***
${API_SESSION}       restful_booker_api
${AUTH_ENDPOINT}     /auth

*** Keywords ***
Create API Session
    [Documentation]    Initialize API session with base configuration
    [Arguments]    ${base_url}=https://restful-booker.herokuapp.com    ${timeout}=30
    Create Session    ${API_SESSION}    ${base_url}    timeout=${timeout}

Generate Auth Token
    [Documentation]    Generate authentication token with configurable credentials
    [Arguments]    ${username}=admin    ${password}=password123
    
    ${auth_payload}=    Create Dictionary    username=${username}    password=${password}
    ${auth_response}=   POST On Session    ${API_SESSION}    ${AUTH_ENDPOINT}    json=${auth_payload}
    
    Validate Response Status    ${auth_response}    200
    ${auth_token}=    Get From Dictionary    ${auth_response.json()}    token
    
    Set Suite Variable    ${CURRENT_AUTH_TOKEN}    ${auth_token}
    RETURN    ${auth_token}

Create Auth Headers
    [Documentation]    Create headers with authentication token
    [Arguments]    ${token}=${CURRENT_AUTH_TOKEN}
    ${auth_headers}=    Create Dictionary    Cookie=token=${token}
    RETURN    ${auth_headers}

