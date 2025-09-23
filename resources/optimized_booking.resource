*** Settings ***
Documentation    Optimized booking keywords with parameterization and reusability
Library          RequestsLibrary
Library          Collections
Resource         optimized_auth.resource

*** Variables ***
${BOOKING_ENDPOINT}    /booking
&{DEFAULT_BOOKING}     firstname=John    lastname=Doe    totalprice=100    depositpaid=${True}    additionalneeds=Breakfast

*** Keywords ***
Create Booking Data
    [Documentation]    Create booking payload with configurable parameters
    [Arguments]    &{booking_details}
    
    # Merge default values with provided parameters
    ${booking_data}=    Create Dictionary    &{DEFAULT_BOOKING}    &{booking_details}
    
    # Create booking dates if not provided
    IF    'bookingdates' not in ${booking_data}
        ${booking_dates}=    Create Dictionary    checkin=2024-01-01    checkout=2024-01-15
        Set To Dictionary    ${booking_data}    bookingdates=${booking_dates}
    END
    
    RETURN    ${booking_data}

Create New Booking
    [Documentation]    Create booking with optional custom data
    [Arguments]    &{booking_details}
    
    ${booking_payload}=    Create Booking Data    &{booking_details}
    ${create_response}=    POST On Session    ${API_SESSION}    ${BOOKING_ENDPOINT}    json=${booking_payload}
    
    Validate Response Status    ${create_response}    200
    ${new_booking_id}=    Get From Dictionary    ${create_response.json()}    bookingid
    
    Set Suite Variable    ${CURRENT_BOOKING_ID}    ${new_booking_id}
    Set Suite Variable    ${LAST_BOOKING_RESPONSE}    ${create_response}
    
    Log    Created booking with ID: ${new_booking_id}
    RETURN    ${new_booking_id}

Get Booking Details
    [Documentation]    Retrieve booking by ID
    [Arguments]    ${booking_id}=${CURRENT_BOOKING_ID}
    
    ${get_response}=    GET On Session    ${API_SESSION}    ${BOOKING_ENDPOINT}/${booking_id}
    Validate Response Status    ${get_response}    200
    
    Set Suite Variable    ${LAST_BOOKING_RESPONSE}    ${get_response}
    RETURN    ${get_response}

Update Booking Details
    [Documentation]    Update existing booking with new data
    [Arguments]    ${booking_id}=${CURRENT_BOOKING_ID}    &{update_data}
    
    ${update_payload}=    Create Booking Data    &{update_data}
    ${auth_headers}=      Create Auth Headers
    
    ${update_response}=    PUT On Session    ${API_SESSION}    ${BOOKING_ENDPOINT}/${booking_id}
    ...                    json=${update_payload}    headers=${auth_headers}
    
    Validate Response Status    ${update_response}    200
    Set Suite Variable    ${LAST_BOOKING_RESPONSE}    ${update_response}
    
    Log    Updated booking ID: ${booking_id}
    RETURN    ${update_response}

Delete Booking
    [Documentation]    Delete booking by ID
    [Arguments]    ${booking_id}=${CURRENT_BOOKING_ID}
    
    ${auth_headers}=       Create Auth Headers
    ${delete_response}=    DELETE On Session    ${API_SESSION}    ${BOOKING_ENDPOINT}/${booking_id}
    ...                    headers=${auth_headers}
    
    Validate Response Status    ${delete_response}    201
    Set Suite Variable    ${LAST_BOOKING_RESPONSE}    ${delete_response}
    
    Log    Deleted booking ID: ${booking_id}
    RETURN    ${delete_response}

Verify Booking Data
    [Documentation]    Verify booking response contains expected data
    [Arguments]    ${response}    &{expected_data}
    
    ${actual_booking}=    Set Variable    ${response.json()}
    
    FOR    ${key}    ${expected_value}    IN    &{expected_data}
        IF    '${key}' != 'bookingdates'
            IF    '${key}' == 'totalprice'
                Should Be Equal As Numbers    ${actual_booking}[${key}]    ${expected_value}
            ELSE IF    '${key}' == 'depositpaid'
                Should Be Equal    ${actual_booking}[${key}]    ${expected_value}
            ELSE
                Should Be Equal    ${actual_booking}[${key}]    ${expected_value}
            END
        ELSE
            Dictionary Should Contain Sub Dictionary    ${actual_booking}[bookingdates]    ${expected_value}
        END
    END

Execute CRUD Workflow
    [Documentation]    Execute complete Create-Read-Update-Delete workflow
    [Arguments]    ${initial_data}    &{update_data}

    
    # Create
    ${booking_id}=    Create New Booking    &{initial_data}
    
    # Read
    ${read_response}=    Get Booking Details    ${booking_id}
    Verify Booking Data    ${read_response}    &{initial_data}
    
    # Update
    ${update_response}=    Update Booking Details    ${booking_id}    &{update_data}
    ${verify_response}=    Get Booking Details    ${booking_id}
    Verify Booking Data    ${verify_response}    &{update_data}
    
    # Delete
    Delete Booking    ${booking_id}
    
    Log    CRUD workflow completed for booking ID: ${booking_id}