@echo off
echo ========================================
echo    Test Environment Setup
echo ========================================

echo Installing Python dependencies...
pip install -r requirements.txt

echo.
echo Creating results directory...
if not exist results mkdir results

echo.
echo Setup completed successfully!
echo You can now run tests using:
echo   - run_tests.bat (for full test execution)
echo   - run_specific_tests.bat (for specific test categories)
echo.
pause