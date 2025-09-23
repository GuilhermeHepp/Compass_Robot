@echo off
echo ========================================
echo    Specific Test Execution Scripts
echo ========================================

echo Select test type to run:
echo 1. Smoke Tests Only
echo 2. Authentication Tests
echo 3. Booking CRUD Tests
echo 4. Integration Tests
echo 5. All Tests
echo.

set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo Running Smoke Tests...
    robot --outputdir results --include smoke tests/
)
if "%choice%"=="2" (
    echo Running Authentication Tests...
    robot --outputdir results tests/auth_tests.robot
)
if "%choice%"=="3" (
    echo Running Booking CRUD Tests...
    robot --outputdir results --include crud tests/booking_tests.robot
)
if "%choice%"=="4" (
    echo Running Integration Tests...
    robot --outputdir results --include integration tests/
)
if "%choice%"=="5" (
    echo Running All Tests...
    robot --outputdir results tests/
)

echo.
echo Test execution completed!
pause