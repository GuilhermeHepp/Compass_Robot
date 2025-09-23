"""Test configuration for different environments"""

class TestConfig:
    # Base API Configuration
    BASE_URL = "https://restful-booker.herokuapp.com"
    
    # Authentication
    DEFAULT_USERNAME = "admin"
    DEFAULT_PASSWORD = "password123"
    
    # Test Data
    DEFAULT_TIMEOUT = 30
    
    # Environment specific configs
    ENVIRONMENTS = {
        "dev": {
            "base_url": "https://restful-booker.herokuapp.com",
            "timeout": 30
        },
        "staging": {
            "base_url": "https://restful-booker.herokuapp.com",
            "timeout": 45
        }
    }
    
    @classmethod
    def get_config(cls, env="dev"):
        return cls.ENVIRONMENTS.get(env, cls.ENVIRONMENTS["dev"])