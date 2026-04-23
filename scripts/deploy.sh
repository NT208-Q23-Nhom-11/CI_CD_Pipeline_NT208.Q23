#!/bin/bash
# Nhận mã SHA mới từ Pipeline
NEW_TAG=$1

if [ -z "$NEW_TAG" ]; then
  echo "Lỗi: Không tìm thấy mã tag (SHA) của image mới."
  exit 1
fi

echo "Đang triển khai phiên bản mới: $NEW_TAG"

# 1. Lưu lại vết phiên bản cũ (Để Rollback)
if [ -f .current_tag ]; then
  cp .current_tag .previous_tag
fi
echo "$NEW_TAG" > .current_tag

# 2. Kéo image mới từ GHCR về
docker pull ghcr.io/nt208-q23-nhom-11/ci_cd_pipeline_nt208.q23:$NEW_TAG

# 3. Khởi động lại hệ thống bằng Docker Compose
export IMAGE_TAG=$NEW_TAG
docker-compose up -d

echo "Triển khai thành công!"