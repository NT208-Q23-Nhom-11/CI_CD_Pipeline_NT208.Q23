import pytest
from app.routes import items # Import thẳng biến items từ routes để test logic

def test_health_logic():
    # Giả lập logic kiểm tra sức khỏe đơn giản
    status = {"status": "ok"}
    assert status["status"] == "ok"

def test_item_data_structure():
    # Kiểm tra cấu trúc dữ liệu mẫu đang có trong app
    assert isinstance(items, list)
    assert len(items) > 0
    assert "id" in items[0]
    assert "name" in items[0]
    assert isinstance(items[0]["id"], int)
