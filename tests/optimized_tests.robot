*** Settings ***
Documentation    Optimized test cases demonstrating best practices
Library          String
Resource         ../resources/optimized_auth.resource
Resource         ../resources/optimized_booking.resource

Suite Setup      Run Keywords
...              Create API Session    AND
...              Generate Auth Token

Suite Teardown   Delete All Sessions

*** Variables ***
@{TEST_USERS}           John Doe    Jane Smith    Bob Wilson
@{BOOKING_PRICES}       100    150    200
&{UPDATE_DATA}          firstname=Updated    lastname=User    totalprice=250

*** Test Cases ***
Test Authentication Token Generation
    [Documentation]    Verify token generation with different credentials
    [Tags]    auth    smoke
    
    ${token}=    Generate Auth Token
    Should Not Be Empty    ${token}
    Length Should Be    ${token}    15

Test Single Booking Creation
    [Documentation]    Test basic booking creation
    [Tags]    booking    smoke
    
    ${booking_id}=    Create New Booking    firstname=Test    lastname=User    totalprice=99
    Should Be True    ${booking_id} > 0

Test Multiple Bookings Creation
    [Documentation]    Create multiple bookings using loop
    [Tags]    booking    data-driven
    
    FOR    ${index}    IN RANGE    3
        ${user}=    Get From List    ${TEST_USERS}    ${index}
        ${price}=    Get From List    ${BOOKING_PRICES}    ${index}
        ${names}=    Split String    ${user}
        ${booking_id}=    Create New Booking    
        ...    firstname=${names}[0]    
        ...    lastname=${names}[1]    
        ...    totalprice=${price}
        
        Log    Created booking ${index + 1}: ID ${booking_id} for ${user}
    END

Test Booking Data Validation
    [Documentation]    Verify booking data integrity
    [Tags]    booking    validation
    
    ${test_data}=    Create Dictionary    firstname=Validation    lastname=Test    totalprice=175
    ${booking_id}=    Create New Booking    &{test_data}
    
    ${response}=    Get Booking Details    ${booking_id}
    Verify Booking Data    ${response}    &{test_data}

Test Complete CRUD Workflow
    [Documentation]    Execute full CRUD operations in single test
    [Tags]    booking    workflow    integration
    
    ${initial_data}=    Create Dictionary    firstname=CRUD    lastname=Test    totalprice=300
    
    Execute CRUD Workflow    ${initial_data}    &{UPDATE_DATA}

Test Parameterized Booking Updates
    [Documentation]    Test booking updates with different data sets
    [Tags]    booking    parameterized
    
    # Create base booking
    ${booking_id}=    Create New Booking    firstname=Base    lastname=Booking
    
    # Test multiple update scenarios
    @{update_scenarios}=    Create List
    ...    firstname=Updated1&lastname=Test1&totalprice=150
    ...    firstname=Updated2&lastname=Test2&totalprice=200
    ...    firstname=Updated3&lastname=Test3&totalprice=250
    
    FOR    ${scenario}    IN    @{update_scenarios}
        ${update_params}=    Evaluate    dict(item.split('=') for item in '${scenario}'.split('&'))
        Update Booking Details    ${booking_id}    &{update_params}
        
        ${verify_response}=    Get Booking Details    ${booking_id}
        Verify Booking Data    ${verify_response}    &{update_params}
    END