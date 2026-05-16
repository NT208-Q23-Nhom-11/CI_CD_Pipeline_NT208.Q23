#!/bin/bash
set -euo pipefail

HEALTH_URL="${1:-http://localhost:5000/health}"
MAX_RETRIES="${MAX_RETRIES:-5}"
RETRY_INTERVAL="${RETRY_INTERVAL:-5}"

echo "[SMOKE] Health URL: $HEALTH_URL"
echo "[SMOKE] Max retries: $MAX_RETRIES"
echo "[SMOKE] Retry interval: ${RETRY_INTERVAL}s"

for attempt in $(seq 1 "$MAX_RETRIES"); do
  echo "[SMOKE] Attempt $attempt/$MAX_RETRIES"

  response="$(curl -fsS "$HEALTH_URL" 2>/tmp/smoke_test_error.log || true)"
  if echo "$response" | grep -q '"status"[[:space:]]*:[[:space:]]*"ok"'; then
    echo "[SMOKE] PASS: /health returned ok"
    exit 0
  fi

  if [ -s /tmp/smoke_test_error.log ]; then
    echo "[SMOKE] curl error: $(cat /tmp/smoke_test_error.log)"
  else
    echo "[SMOKE] Unexpected response: ${response:-<empty>}"
  fi

  if [ "$attempt" -lt "$MAX_RETRIES" ]; then
    echo "[SMOKE] Waiting ${RETRY_INTERVAL}s before retry..."
    sleep "$RETRY_INTERVAL"
  fi
done

echo "[SMOKE] FAIL: /health did not become healthy after $MAX_RETRIES attempts"
exit 1
