*** Variables ***
# API Configuration
${BASE_URL}              https://restful-booker.herokuapp.com
${TIMEOUT}               120

# API Endpoints
${AUTH_ENDPOINT}         /auth
${BOOKING_ENDPOINT}      /booking

# Session Configuration
${API_SESSION}           api_session

# Test Data Configuration
${DEFAULT_DATA_FILE}     booking_data.json

# Authentication
${DEFAULT_USERNAME}      admin
${DEFAULT_PASSWORD}      password123