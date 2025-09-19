*** Settings ***    

Library    RequestsLibrary
Library    String
Resource   api_testing_auth.resource


*** Keywords ***

Criar um novo booking
    ${booking_dates}=    Create Dictionary
    ...    checkin=2024-01-01
    ...    checkout=2024-01-15

    ${payload}=          Create Dictionary
    ...    firstname=Jome
    ...    lastname=Brown
    ...    totalprice=${111}
    ...    depositpaid=${True}
    ...    bookingdates=${booking_dates}
    ...    additionalneeds=Breakfast

    ${response}=         POST On Session
    ...    api_testing
    ...    /booking
    ...    json=${payload}

    Log To Console    Response=${response.status_code}
    Set Suite Variable    ${booking_id}    ${response.json()['bookingid']}
    Log To Console    Booking ID=${booking_id}
    Set Suite Variable   ${response}


Conferir se o booking foi criado com sucesso
    Should Be Equal As Integers    ${response.status_code}    200

Consultar um booking existente
    ${response}=    GET On Session    
    ...    api_testing    
    ...    /booking/${booking_id}
    Log To Console    Response=${response.status_code}

Conferir se o booking foi consultado com sucesso
    Should Be Equal As Integers    ${response.status_code}    200

Atualizar um booking existente
    ${token}=    Criar um token novo

    ${header}=    Create Dictionary    Cookie=token=${token}

    ${booking_dates}=    Create Dictionary
    ...    checkin=2023-11-01
    ...    checkout=2023-11-10
    ${payload}=    Create Dictionary    
    ...    firstname=Jane    
    ...    lastname=Doe    
    ...    totalprice=200    
    ...    depositpaid=false    
    ...    bookingdates=${booking_dates}
    ...    additionalneeds=Lunch

    ${response}=    PUT On Session    
    ...    api_testing    
    ...    /booking/${booking_id}  
    ...    json=${payload}   
    ...    headers=${header}
    Log To Console    Response=${response.status_code}

Conferir se o booking foi atualizado com sucesso
    Should Be Equal As Integers    ${response.status_code}    200

Deletar um booking existente
    ${token}=    Criar um token novo

    ${header}=    Create Dictionary    Cookie=token=${token}

    ${response}=    DELETE On Session    
    ...    api_testing    
    ...    /booking/${booking_id}  
    ...    headers=${header}
    Log To Console    Response=${response.status_code}

Conferir se o booking foi deletado com sucesso
    Should Be Equal As Integers    ${response.status_code}    200