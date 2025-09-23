*** Settings ***
Resource    common_keywords.resource
Resource    auth_keywords.resource
Library     RequestsLibrary

*** Variables ***
${BOOKING_ENDPOINT}    /booking

*** Keywords ***
Create New Booking
    [Documentation]    Create a new booking with provided data
    [Arguments]    ${booking_data}
    
    ${response}=    POST On Session
    ...    api_session
    ...    ${BOOKING_ENDPOINT}
    ...    json=${booking_data}
    ...    expected_status=200
    
    Log Response Details    ${response}
    
    ${booking_id}=    Get Value From Json    ${response.json()}    $.bookingid
    ${booking_id}=    Get From List    ${booking_id}    0
    
    Set Suite Variable    ${CURRENT_BOOKING_ID}    ${booking_id}
    Set Suite Variable    ${CREATE_RESPONSE}    ${response}
    
    RETURN    ${booking_id}

Get Booking By ID
    [Documentation]    Retrieve booking details by ID
    [Arguments]    ${booking_id}=${CURRENT_BOOKING_ID}
    
    ${response}=    GET On Session
    ...    api_session
    ...    ${BOOKING_ENDPOINT}/${booking_id}
    ...    expected_status=200
    
    Log Response Details    ${response}
    Set Suite Variable    ${GET_RESPONSE}    ${response}
    
    RETURN    ${response}

Update Booking
    [Documentation]    Update existing booking with new data
    [Arguments]    ${booking_id}    ${booking_data}    ${token}=${AUTH_TOKEN}
    
    ${headers}=    Create Auth Headers    ${token}
    
    ${response}=    PUT On Session
    ...    api_session
    ...    ${BOOKING_ENDPOINT}/${booking_id}
    ...    json=${booking_data}
    ...    headers=${headers}
    ...    expected_status=200
    
    Log Response Details    ${response}
    Set Suite Variable    ${UPDATE_RESPONSE}    ${response}
    
    RETURN    ${response}

Delete Booking
    [Documentation]    Delete booking by ID
    [Arguments]    ${booking_id}    ${token}=${AUTH_TOKEN}
    
    ${headers}=    Create Auth Headers    ${token}
    
    ${response}=    DELETE On Session
    ...    api_session
    ...    ${BOOKING_ENDPOINT}/${booking_id}
    ...    headers=${headers}
    ...    expected_status=201
    
    Log Response Details    ${response}
    Set Suite Variable    ${DELETE_RESPONSE}    ${response}
    
    RETURN    ${response}

Verify Booking Data
    [Documentation]    Verify booking data matches expected values
    [Arguments]    ${response}    ${expected_data}
    
    ${actual_data}=    Set Variable    ${response.json()}
    
    Should Be Equal    ${actual_data['firstname']}    ${expected_data['firstname']}
    Should Be Equal    ${actual_data['lastname']}    ${expected_data['lastname']}
    Should Be Equal As Numbers    ${actual_data['totalprice']}    ${expected_data['totalprice']}
    Should Be Equal    ${actual_data['depositpaid']}    ${expected_data['depositpaid']}
    Should Be Equal    ${actual_data['additionalneeds']}    ${expected_data['additionalneeds']}