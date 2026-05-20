#!/bin/bash
set -euo pipefail

HEALTH_URL="${1:-http://localhost:5000/health}"
MAX_RETRIES="${MAX_RETRIES:-5}"
RETRY_INTERVAL="${RETRY_INTERVAL:-5}"
ERROR_LOG="${ERROR_LOG:-/tmp/smoke_test_error.log}"

HEALTH_URL="${HEALTH_URL//$'\r'/}"
MAX_RETRIES="${MAX_RETRIES//$'\r'/}"
RETRY_INTERVAL="${RETRY_INTERVAL//$'\r'/}"

echo "[SMOKE] Health URL: $HEALTH_URL"
echo "[SMOKE] Max retries: $MAX_RETRIES"
echo "[SMOKE] Retry interval: ${RETRY_INTERVAL}s"

for attempt in $(seq 1 "$MAX_RETRIES"); do
  echo "[SMOKE] Attempt $attempt/$MAX_RETRIES"

  response="$(curl -fsS "$HEALTH_URL" 2>"$ERROR_LOG" || true)"
  if echo "$response" | grep -q '"status"[[:space:]]*:[[:space:]]*"ok"'; then
    echo "[SMOKE] PASS: /health returned ok"
    exit 0
  fi

  if [ -s "$ERROR_LOG" ]; then
    echo "[SMOKE] curl error: $(cat "$ERROR_LOG")"
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
