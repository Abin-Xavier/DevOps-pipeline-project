#!/usr/bin/env bash
# Deploy an image tag, verify /health, roll back to the last good tag on failure.
# Usage: deploy.sh <image-tag>
set -uo pipefail

TAG="${1:?Usage: deploy.sh <image-tag>}"
APP_DIR="$HOME/app"
STATE_FILE="$APP_DIR/last_good_tag"
COMPOSE="$APP_DIR/docker-compose.prod.yml"
HEALTH_URL="http://127.0.0.1:8081/health"
export DOCKERHUB_USERNAME="${DOCKERHUB_USERNAME:?DOCKERHUB_USERNAME is not set}"

log() { echo "[deploy $(date +%H:%M:%S)] $*"; }

start_stack() {
  local tag="$1"
  IMAGE_TAG="$tag" docker compose -f "$COMPOSE" pull
  IMAGE_TAG="$tag" docker compose -f "$COMPOSE" up -d --remove-orphans --force-recreate
}

wait_healthy() {
  local tries=30
  for i in $(seq 1 "$tries"); do
    if curl -fsS --max-time 3 "$HEALTH_URL" >/dev/null 2>&1; then
      log "health check passed (attempt $i)"
      return 0
    fi
    log "waiting for /health ($i/$tries)"
    sleep 4
  done
  return 1
}

PREVIOUS="none"
[ -f "$STATE_FILE" ] && PREVIOUS="$(cat "$STATE_FILE")"
log "deploying tag $TAG (previous good tag: $PREVIOUS)"

if start_stack "$TAG" && wait_healthy; then
  echo "$TAG" > "$STATE_FILE"
  log "SUCCESS: $TAG is live and recorded as the last good tag"
  exit 0
fi

log "FAILURE: $TAG did not become healthy"
if [ "$PREVIOUS" != "none" ]; then
  log "ROLLING BACK to $PREVIOUS"
  start_stack "$PREVIOUS"
  if wait_healthy; then
    log "ROLLBACK OK: $PREVIOUS is live again"
  else
    log "ROLLBACK FAILED: manual intervention needed"
  fi
else
  log "no previous good tag exists, nothing to roll back to"
  IMAGE_TAG="$TAG" docker compose -f "$COMPOSE" logs --tail 40 || true
fi
exit 1
