#!/bin/bash
set -e

REPO=$1
PREV_FILE="$HOME/staging/.previous_tag"

# Kiểm tra xem có file lưu tag cũ không
if [ ! -f "$PREV_FILE" ]; then
  echo "[ROLLBACK] FAIL - Không tìm thấy file .previous_tag. Không thể rollback."
  exit 1
fi

PREV_TAG=$(cat "$PREV_FILE")
echo "[ROLLBACK] Khôi phục về image tag: $PREV_TAG"

# Dừng app hiện tại và chạy lại app cũ
export IMAGE_TAG=$PREV_TAG
export REPO_NAME=$REPO
docker compose pull app
docker compose up -d app

# Cập nhật lại current tag
echo $PREV_TAG > "$HOME/staging/.current_tag"

echo "[ROLLBACK] Hoàn thành. Staging đã trở về tag: $PREV_TAG"
