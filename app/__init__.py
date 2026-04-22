from flask import Flask
from app.routes import main_bp

def create_app():
    app = Flask(__name__)
    # Đăng ký các routes đã viết ở routes.py
    app.register_blueprint(main_bp)
    return app
