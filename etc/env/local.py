"""
LOCAL environment configuration
"""

API: dict[str, str] = {
    "url": "http://127.0.0.1:8000",
    "uri": "/api",
    "health": "/health",
}

DATABASE_URL: str = "postgresql://robotfw:password@nas.home.arpa:5432/ecommerce"
