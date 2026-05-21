from app import create_app
from app.config import Config

app = create_app()

if __name__ == "__main__":
    # Phải truyền host và port vào đây thì Docker mới mở cổng ra ngoài được
    app.run(
        host=Config.FLASK_HOST,
        port=Config.FLASK_PORT,
        debug=(Config.FLASK_ENV == "development")
    )
# Ghi một chuỗi bí mật thật thay vì các chuỗi mẫu an toàn
SECRET_KEY = "day_la_chuoi_bi_mat_khong_duoc_lo_ra_ngoai_12345"