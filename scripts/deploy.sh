#!/bin/bash
set -e # Dừng ngay nếu có bất kỳ lệnh nào lỗi

NEW_TAG=$1

if [ -z "$NEW_TAG" ]; then
  echo "Lỗi: Không tìm thấy mã tag (SHA) của image mới."
  exit 1
fi

echo "--- BẮT ĐẦU TRIỂN KHAI PHIÊN BẢN: $NEW_TAG ---"

# 1. Lưu lại vết phiên bản cũ để phục vụ Rollback
if [ -f .current_tag ]; then
  cp .current_tag .previous_tag
fi
echo "$NEW_TAG" > .current_tag

# 2. DỌN DẸP HỆ THỐNG TRƯỚC KHI LÊN BẢN MỚI
# Dừng và xóa sạch các container, network cũ của project để tránh xung đột cổng
echo "--- Đang dọn dẹp bản cũ (docker-compose down) ---"
docker-compose down --remove-orphans

# Giải phóng RAM và Disk (Xóa các image cũ không dùng tới)
# Lệnh này giúp máy ảo B1s luôn sạch sẽ trước khi chạy bản mới
echo "--- Đang giải phóng tài nguyên (docker system prune) ---"
docker system prune -f

# 3. KÉO IMAGE MỚI VỀ
echo "--- Đang kéo image mới từ GHCR ---"
docker pull ghcr.io/nt208-q23-nhom-11/ci_cd_pipeline_nt208.q23:$NEW_TAG

# 4. KHỞI CHẠY HỆ THỐNG
echo "--- Đang khởi động container mới ---"
export IMAGE_TAG=$NEW_TAG
docker-compose up -d

echo "Triển khai thành công phiên bản $NEW_TAG!"