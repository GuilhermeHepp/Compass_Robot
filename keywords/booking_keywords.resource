*** Settings ***
Resource    common_keywords.resource
Resource    auth_keywords.resource
Resource    ../variables/global_variables.resource
Library     RequestsLibrary

*** Keywords ***
Create New Booking
    [Documentation]    Create a new booking with provided data
    [Arguments]    ${booking_data}
    
    FOR    ${attempt}    IN RANGE    3
        ${status}=    Run Keyword And Return Status
        ...    POST On Session    ${API_SESSION}    ${BOOKING_ENDPOINT}    json=${booking_data}    expected_status=200
        IF    ${status}
            ${response}=    POST On Session    ${API_SESSION}    ${BOOKING_ENDPOINT}    json=${booking_data}    expected_status=200
            BREAK
        END
        Sleep    2s
    END
    
    Should Be True    ${status}    Failed to create booking after 3 attempts
    
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
    ...    ${API_SESSION}
    ...    ${BOOKING_ENDPOINT}/${booking_id}
    ...    expected_status=any
    
    Log Response Details    ${response}
    Set Suite Variable    ${GET_RESPONSE}    ${response}
    
    RETURN    ${response}

Update Booking
    [Documentation]    Update existing booking with new data
    [Arguments]    ${booking_id}    ${booking_data}    ${token}=${AUTH_TOKEN}
    
    ${headers}=    Create Auth Headers    ${token}
    
    ${response}=    PUT On Session
    ...    ${API_SESSION}
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
    ...    ${API_SESSION}
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