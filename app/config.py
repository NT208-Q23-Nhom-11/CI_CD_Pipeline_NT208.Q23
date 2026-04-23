import os


class Config:
    APP_VERSION = os.getenv("APP_VERSION", "dev")
    FLASK_ENV = os.getenv("FLASK_ENV", "development")
    FLASK_HOST = os.getenv("FLASK_HOST", "0.0.0.0")
    FLASK_PORT = int(os.getenv("FLASK_PORT", "5000"))
    SECRET_KEY = os.getenv("SECRET_KEY", "change-me")
