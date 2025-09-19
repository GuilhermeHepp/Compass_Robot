*** Settings ***
Library    RequestsLibrary
Library    String

*** Keywords ***
Criar sessão para API
    Create Session    api_testing    https://restful-booker.herokuapp.com
Criar um token novo
    ${payload}=    Create Dictionary       
    ...    username=admin    
    ...    password=password123
    ${response}=    POST On Session   
    ...    api_testing    
    ...    /auth    
    ...    json=${payload}
    Log To Console    Response=${response.status_code}
    Set Suite Variable    ${status}    ${response.status_code}
    ${token}=        Set Variable       ${response.json()['token']}
    RETURN         ${token}

Conferir se o token foi criado com sucesso
    Should Be Equal As Integers    ${status}    200