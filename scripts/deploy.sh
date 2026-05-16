#!/bin/bash
set -euo pipefail

NEW_TAG="${1:-}"
REGISTRY_IMAGE="${REGISTRY_IMAGE:-ghcr.io/nt208-q23-nhom-11/ci_cd_pipeline_nt208.q23}"
STATE_DIR="${STATE_DIR:-$HOME/staging-state/ci-cd-pipeline}"
CURRENT_TAG_FILE="$STATE_DIR/.current_tag"
PREVIOUS_TAG_FILE="$STATE_DIR/.previous_tag"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
COMPOSE_FILE="${COMPOSE_FILE:-$PROJECT_DIR/docker-compose.yml}"

compose() {
  if docker compose version >/dev/null 2>&1; then
    docker compose -f "$COMPOSE_FILE" "$@"
  else
    docker-compose -f "$COMPOSE_FILE" "$@"
  fi
}

if [ -z "$NEW_TAG" ]; then
  echo "[DEPLOY] FAIL: missing image tag argument."
  echo "Usage: scripts/deploy.sh <full_commit_sha_or_image_tag>"
  exit 1
fi

mkdir -p "$STATE_DIR"

echo "[DEPLOY] Registry image: $REGISTRY_IMAGE"
echo "[DEPLOY] New tag: $NEW_TAG"
echo "[DEPLOY] State dir: $STATE_DIR"

echo "[DEPLOY] Pulling image before touching the running container..."
docker pull "$REGISTRY_IMAGE:$NEW_TAG"

if [ -s "$CURRENT_TAG_FILE" ]; then
  CURRENT_TAG="$(cat "$CURRENT_TAG_FILE")"
  echo "$CURRENT_TAG" > "$PREVIOUS_TAG_FILE"
  echo "[DEPLOY] Previous tag saved: $CURRENT_TAG"
else
  echo "[DEPLOY] No current tag found. This looks like the first deploy."
fi

export IMAGE_TAG="$NEW_TAG"
export REGISTRY_IMAGE

echo "[DEPLOY] Stopping old container, if any..."
compose down --remove-orphans || true

echo "[DEPLOY] Starting new container..."
compose up -d

echo "$NEW_TAG" > "$CURRENT_TAG_FILE"
echo "[DEPLOY] Done. Current tag: $NEW_TAG"
