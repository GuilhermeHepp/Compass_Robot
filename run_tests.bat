@echo off
echo ========================================
echo    Robot Framework Test Automation
echo ========================================

REM Set default values
set TEST_ENV=dev
set TEST_SUITE=tests
set OUTPUT_DIR=results
set LOG_LEVEL=INFO

REM Parse command line arguments
:parse_args
if "%1"=="" goto run_tests
if "%1"=="--env" (
    set TEST_ENV=%2
    shift
    shift
    goto parse_args
)
if "%1"=="--suite" (
    set TEST_SUITE=%2
    shift
    shift
    goto parse_args
)
if "%1"=="--output" (
    set OUTPUT_DIR=%2
    shift
    shift
    goto parse_args
)
if "%1"=="--loglevel" (
    set LOG_LEVEL=%2
    shift
    shift
    goto parse_args
)
shift
goto parse_args

:run_tests
echo Environment: %TEST_ENV%
echo Test Suite: %TEST_SUITE%
echo Output Directory: %OUTPUT_DIR%
echo Log Level: %LOG_LEVEL%
echo.

REM Create output directory if it doesn't exist
if not exist %OUTPUT_DIR% mkdir %OUTPUT_DIR%

REM Run Robot Framework tests
robot --outputdir %OUTPUT_DIR% ^
      --loglevel %LOG_LEVEL% ^
      --variable ENV:%TEST_ENV% ^
      --include smoke ^
      --report report.html ^
      --log log.html ^
      --output output.xml ^
      %TEST_SUITE%

echo.
echo ========================================
echo Test execution completed!
echo Check results in: %OUTPUT_DIR%
echo ========================================
pause