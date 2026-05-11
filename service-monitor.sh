#!/bin/bash

# This script is meant to monitor docker containers which run services for a home server
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
source "${SCRIPT_DIR}/.env"

mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/service-monitor-$(date +%F).log"

log() {
  printf '[%s] %s\n' "$(date +'%F %T')" "$*" | tee -a "${LOG_FILE}"
}

log ""
log "service-monitor.sh is starting..."

# Add the variables based on your containers
containers=(homeassistant nextcloud)

for container in "${containers[@]}" ; do 
  log "Now checking container: $container"
  read -r status exit_code < <(docker inspect -f '{{.State.Status}} {{.State.ExitCode}}' "$container")
  case "$status" in 
    running)
      log "$container is running normally"
      ;;
    paused)
      log "$container is paused"
      ;;
    restarting)
      log "$container is probably in a restart loop"
      curl -d "$container is probably in a restart loop, check please" "$NTFY_URL"
      ;;
    exited|dead)
      log "$container has exited with code $exit_code" 
      curl -d "$container has exited with code $exit_code" "$NTFY_URL"
      ;;
    *)
      log "Whatever... unimportant status"
  esac
done
