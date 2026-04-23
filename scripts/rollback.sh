#!/bin/bash
set -e
echo "Phát hiện lỗi! Đang tiến hành Rollback..."

# 1. Kiểm tra bản backup
if [ ! -f .previous_tag ]; then
  echo "Lỗi: Không tìm thấy phiên bản cũ để quay xe."
  exit 1
fi

PREV_TAG=$(cat .previous_tag)
echo "Đang khôi phục về phiên bản: $PREV_TAG"

# 2. DỌN DẸP SẠCH SẼ MÔI TRƯỜNG LỖI (Quan trọng nhất)
echo "--- Đang dọn dẹp bản deploy lỗi ---"
docker-compose down --remove-orphans || true
docker system prune -af

# 3. KHỞI CHẠY LẠI BẢN CŨ
echo "$PREV_TAG" > .current_tag
export IMAGE_TAG=$PREV_TAG
docker-compose up -d

echo "Khôi phục thành công!"