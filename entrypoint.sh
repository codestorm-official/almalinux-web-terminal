#!/usr/bin/env bash
set -euo pipefail

PORT="${PORT:-7681}"
USERNAME="${USERNAME:-admin}"
WORKSPACE_DIR="${WORKSPACE_DIR:-/root/workspace}"

if [[ -z "${PASSWORD:-}" ]]; then
  echo "ERROR: PASSWORD environment variable is required." >&2
  echo "Set PASSWORD in Railway Variables before exposing this terminal." >&2
  exit 1
fi

if [[ -n "${TZ:-}" && -f "/usr/share/zoneinfo/${TZ}" ]]; then
  ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
  echo "${TZ}" >/etc/timezone
fi

mkdir -p "${WORKSPACE_DIR}"
cd "${WORKSPACE_DIR}"

echo "Starting AlmaLinux ${ALMALINUX_VERSION:-unknown} web terminal on 0.0.0.0:${PORT}"
echo "Workspace: ${WORKSPACE_DIR}"

exec /usr/local/bin/ttyd \
  -i 0.0.0.0 \
  -p "${PORT}" \
  -c "${USERNAME}:${PASSWORD}" \
  -t titleFixed="AlmaLinux Web Terminal" \
  -t fontSize=14 \
  /bin/bash -l
