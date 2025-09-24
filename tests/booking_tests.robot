*** Settings ***
Documentation    Booking API Tests - Complete CRUD Operations
Resource         ../keywords/common_keywords.resource
Resource         ../keywords/auth_keywords.resource
Resource         ../keywords/booking_keywords.resource

Suite Setup      Run Keywords
...              Setup Test Session    AND
...              Generate Authentication Token

Suite Teardown   Teardown Test Session

*** Variables ***
${TEST_DATA}    ${EMPTY}

*** Test Cases ***
Test Create New Booking
    [Documentation]    Verify booking creation with valid data
    [Tags]    booking    crud    smoke
    
    ${test_data}=    Load Test Data
    ${booking_data}=    Get From Dictionary    ${test_data}    valid_bookings
    ${booking_data}=    Get From List    ${booking_data}    0
    
    ${booking_id}=    Create New Booking    ${booking_data}
    Should Be True    ${booking_id} > 0
    
    Log    Created Booking ID: ${booking_id}

Test Get Existing Booking
    [Documentation]    Verify retrieval of existing booking
    [Tags]    booking    crud
    
    ${test_data}=    Load Test Data
    ${booking_data}=    Get From Dictionary    ${test_data}    valid_bookings
    ${booking_data}=    Get From List    ${booking_data}    0
    Create New Booking    ${booking_data}
    
    ${response}=    Get Booking By ID
    Validate Response Status    ${response}    200
    
    ${test_data}=    Load Test Data
    ${expected_data}=    Get From Dictionary    ${test_data}    valid_bookings
    ${expected_data}=    Get From List    ${expected_data}    0
    
    Verify Booking Data    ${response}    ${expected_data}

Test Update Existing Booking
    [Documentation]    Verify booking update functionality
    [Tags]    booking    crud
    
    ${test_data}=    Load Test Data
    ${booking_data}=    Get From Dictionary    ${test_data}    valid_bookings
    ${booking_data}=    Get From List    ${booking_data}    0
    Create New Booking    ${booking_data}
    
    ${test_data}=    Load Test Data
    ${update_data}=    Get From Dictionary    ${test_data}    update_booking
    
    ${response}=    Update Booking    ${CURRENT_BOOKING_ID}    ${update_data}
    Validate Response Status    ${response}    200
    
    # Verify the update was successful
    ${get_response}=    Get Booking By ID    ${CURRENT_BOOKING_ID}
    Verify Booking Data    ${get_response}    ${update_data}

Test Delete Existing Booking
    [Documentation]    Verify booking deletion functionality
    [Tags]    booking    crud
    
    ${test_data}=    Load Test Data
    ${booking_data}=    Get From Dictionary    ${test_data}    valid_bookings
    ${booking_data}=    Get From List    ${booking_data}    1
    Create New Booking    ${booking_data}
    
    ${response}=    Delete Booking    ${CURRENT_BOOKING_ID}
    Validate Response Status    ${response}    201
    
    # Verify booking is deleted
    ${get_response}=    Get Booking By ID    ${CURRENT_BOOKING_ID}
    Should Be Equal As Integers    ${get_response.status_code}    404

Test Complete Booking Workflow
    [Documentation]    Test complete booking lifecycle: Create -> Read -> Update -> Delete
    [Tags]    booking    workflow    integration
    
    ${test_data}=    Load Test Data
    ${booking_data}=    Get From Dictionary    ${test_data}    valid_bookings
    ${booking_data}=    Get From List    ${booking_data}    0
    
    # Create
    ${booking_id}=    Create New Booking    ${booking_data}
    Log    Step 1: Created booking ${booking_id}
    
    # Read
    ${get_response}=    Get Booking By ID    ${booking_id}
    Verify Booking Data    ${get_response}    ${booking_data}
    Log    Step 2: Retrieved and verified booking
    
    # Update
    ${update_data}=    Get From Dictionary    ${test_data}    update_booking
    Update Booking    ${booking_id}    ${update_data}
    ${updated_response}=    Get Booking By ID    ${booking_id}
    Verify Booking Data    ${updated_response}    ${update_data}
    Log    Step 3: Updated and verified booking
    
    # Delete
    Delete Booking    ${booking_id}
    Log    Step 4: Deleted booking