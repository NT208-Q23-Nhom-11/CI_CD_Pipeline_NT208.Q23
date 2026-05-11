#!/bin/bash
set -e 

NEW_TAG=$1
if [ -z "$NEW_TAG" ]; then
  echo "Lỗi: Không tìm thấy mã tag (SHA)."
  exit 1
fi

echo "--- TRIỂN KHAI PHIÊN BẢN: $NEW_TAG ---"

# 1. Lưu tag cũ
[ -f .current_tag ] && cp .current_tag .previous_tag
echo "$NEW_TAG" > .current_tag

# 2. DỌN DẸP TRIỆT ĐỂ (Như ông làm tay)
echo "--- Dừng bản cũ ---"
docker-compose down --remove-orphans || true # Thêm || true để không bị chết script nếu không có container

echo "--- Giải phóng toàn bộ tài nguyên (Sửa từ -f thành -af) ---"
docker system prune -af # Xóa sạch các image SHA cũ để trống RAM/Disk

# 3. CHẠY BẢN MỚI
echo "--- Kéo và chạy bản mới ---"
docker pull ghcr.io/nt208-q23-nhom-11/ci_cd_pipeline_nt208.q23:$NEW_TAG
export IMAGE_TAG=$NEW_TAG
docker-compose up -d

echo "Đã xong! Hệ thống sạch sẽ và đang chạy bản $NEW_TAG"