*** Settings ***
Documentation    Authentication API Tests
Resource         ../keywords/common_keywords.resource
Resource         ../keywords/auth_keywords.resource

Suite Setup      Setup Test Session
Suite Teardown   Teardown Test Session

*** Test Cases ***
Test Generate Valid Authentication Token
    [Documentation]    Verify that valid credentials generate authentication token
    [Tags]    auth    smoke
    
    ${token}=    Generate Authentication Token
    Should Not Be Empty    ${token}
    Length Should Be    ${token}    15
    Log    Generated Token: ${token}

Test Generate Token With Invalid Credentials
    [Documentation]    Verify that invalid credentials return error
    [Tags]    auth    negative
    
    Run Keyword And Expect Error    *
    ...    Generate Authentication Token    invalid_user    invalid_pass

Test Token Can Be Used For Authentication
    [Documentation]    Verify generated token works for authenticated requests
    [Tags]    auth    integration
    
    ${token}=    Generate Authentication Token
    ${headers}=    Create Auth Headers    ${token}
    
    Should Contain    ${headers}    Cookie
    Should Contain    ${headers['Cookie']}    token=${token}