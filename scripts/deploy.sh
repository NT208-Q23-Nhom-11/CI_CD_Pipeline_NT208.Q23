#!/bin/bash
IMAGE_TAG=$1
REPO=$2
USER=$3
TOKEN=$4

TAG_FILE="$HOME/staging/.current_tag"
PREV_FILE="$HOME/staging/.previous_tag"

# Lưu tag cũ (FR-036)
[ -f "$TAG_FILE" ] && cp "$TAG_FILE" "$PREV_FILE"

# Login và Pull bản mới
echo $TOKEN | docker login ghcr.io -u $USER --password-stdin
docker pull ghcr.io/$REPO:$IMAGE_TAG

# Chạy container mới
IMAGE_TAG=$IMAGE_TAG docker compose up -d

# Smoke Test (FR-044)
SUCCESS=0
for i in {1..5}; do
  if curl -s http://localhost:5000/health | grep -q "ok"; then
    SUCCESS=1; break
  fi
  sleep 5
done

if [ $SUCCESS -eq 1 ]; then
  echo $IMAGE_TAG > "$TAG_FILE"
else
  echo "Smoke test fail! Rolling back..."
  ./scripts/rollback.sh $REPO
  exit 1
fi
