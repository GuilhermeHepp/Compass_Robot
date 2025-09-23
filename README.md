# Robot Framework API Test Automation

## Project Structure

```
Compass_Robot/
├── config/                 # Configuration files
│   └── test_config.py      # Environment configurations
├── data/                   # Test data files
│   └── booking_data.json   # Booking test data
├── keywords/               # Reusable keywords
│   ├── common_keywords.resource      # Common utilities
│   ├── auth_keywords.resource        # Authentication keywords
│   └── booking_keywords.resource     # Booking operations
├── tests/                  # Test cases
│   ├── auth_tests.robot    # Authentication tests
│   └── booking_tests.robot # Booking CRUD tests
├── utils/                  # Utility scripts
├── results/                # Test execution results
└── requirements.txt        # Python dependencies
```

## Quick Start

1. **Setup Environment:**
   ```bash
   setup.bat
   ```

2. **Run All Tests:**
   ```bash
   run_tests.bat
   ```

3. **Run Specific Tests:**
   ```bash
   run_specific_tests.bat
   ```

## Test Categories

- **Smoke Tests:** `--include smoke`
- **CRUD Tests:** `--include crud`
- **Integration Tests:** `--include integration`
- **Authentication Tests:** `tests/auth_tests.robot`

## Features

- ✅ Modular keyword structure
- ✅ Data-driven testing
- ✅ Environment configuration
- ✅ Comprehensive error handling
- ✅ Detailed logging and reporting
- ✅ Automated test execution scripts
- ✅ Tag-based test filtering

## Usage Examples

```bash
# Run smoke tests only
robot --include smoke tests/

# Run with specific environment
robot --variable ENV:staging tests/

# Run specific test file
robot tests/booking_tests.robot
```