*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    JSONLibrary
Resource   ../variables/global_variables.resource

*** Keywords ***
Setup Test Session
    [Documentation]    Initialize API session for testing
    Create Session    ${API_SESSION}    ${BASE_URL}    timeout=${TIMEOUT}

Teardown Test Session
    [Documentation]    Clean up API session
    Delete All Sessions

Load Test Data
    [Documentation]    Load test data from JSON file
    [Arguments]    ${data_file}=${DEFAULT_DATA_FILE}
    ${data_path}=    Join Path    ${EXECDIR}    data    ${data_file}
    ${test_data}=    Load JSON From File    ${data_path}
    RETURN    ${test_data}

Validate Response Status
    [Documentation]    Validate HTTP response status code
    [Arguments]    ${response}    ${expected_status}=200
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    Log    Response Status: ${response.status_code}

Log Response Details
    [Documentation]    Log detailed response information
    [Arguments]    ${response}
    Log    Status Code: ${response.status_code}
    Log    Response Headers: ${response.headers}
    Log    Response Body: ${response.text}