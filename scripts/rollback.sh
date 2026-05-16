#!/bin/bash
set -euo pipefail

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

if [ ! -s "$PREVIOUS_TAG_FILE" ]; then
  echo "[ROLLBACK] FAIL: previous tag file not found or empty: $PREVIOUS_TAG_FILE"
  exit 1
fi

PREVIOUS_TAG="$(cat "$PREVIOUS_TAG_FILE")"
CURRENT_TAG="unknown"
if [ -s "$CURRENT_TAG_FILE" ]; then
  CURRENT_TAG="$(cat "$CURRENT_TAG_FILE")"
fi

echo "[ROLLBACK] Registry image: $REGISTRY_IMAGE"
echo "[ROLLBACK] Current tag before rollback: $CURRENT_TAG"
echo "[ROLLBACK] Rolling back to previous tag: $PREVIOUS_TAG"

docker pull "$REGISTRY_IMAGE:$PREVIOUS_TAG" || \
  echo "[ROLLBACK] Pull failed, continuing with local image cache if available."

export IMAGE_TAG="$PREVIOUS_TAG"
export REGISTRY_IMAGE

echo "[ROLLBACK] Stopping failed container, if any..."
compose down --remove-orphans || true

echo "[ROLLBACK] Starting previous version..."
compose up -d

echo "$PREVIOUS_TAG" > "$CURRENT_TAG_FILE"
echo "[ROLLBACK] Done. Current tag is now: $PREVIOUS_TAG"
