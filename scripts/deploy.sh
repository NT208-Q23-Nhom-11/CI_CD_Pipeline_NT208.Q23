#!/bin/bash
set -e
NEW_TAG=$1

echo "Triển khai phiên bản: $NEW_TAG"

# Lưu vết để rollback
if [ -f .current_tag ]; then
  cp .current_tag .previous_tag
fi
echo "$NEW_TAG" > .current_tag

export IMAGE_TAG=$NEW_TAG

# Tắt sạch bản cũ trước khi bật bản mới để tránh xung đột port
docker-compose down 
docker-compose up -d

echo "Triển khai thành công!"