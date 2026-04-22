import os

class Config:
    APP_VERSION = os.getenv("APP_VERSION", "1.0.0")
    FLASK_ENV = os.getenv("FLASK_ENV", "development")
    # Secret key dùng cho session, bảo mật (FR-050)
    SECRET_KEY = os.getenv("SECRET_KEY", "dev-secret-key")
