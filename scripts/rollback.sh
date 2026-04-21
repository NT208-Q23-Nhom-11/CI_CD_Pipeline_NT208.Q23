#!/bin/bash
echo "Phát hiện lỗi! Đang tiến hành Rollback..."

# Kiểm tra xem có bản backup nào không
if [ ! -f .previous_tag ]; then
  echo "Lỗi: Không tìm thấy phiên bản cũ để quay xe."
  exit 1
fi

PREV_TAG=$(cat .previous_tag)
echo "Đang khôi phục về phiên bản: $PREV_TAG"

# Khôi phục file tag
echo "$PREV_TAG" > .current_tag

# Khởi động lại bản cũ
export IMAGE_TAG=$PREV_TAG
docker-compose up -d

echo "Khôi phục thành công!"