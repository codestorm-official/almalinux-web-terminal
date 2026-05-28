#!/usr/bin/env bash
set -euo pipefail

PORT="${PORT:-7681}"
USERNAME="${USERNAME:-admin}"
WORKSPACE_DIR="${WORKSPACE_DIR:-/root/workspace}"
TTYD_WRITABLE="${TTYD_WRITABLE:-true}"

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

ttyd_args=(
  -i 0.0.0.0
  -p "${PORT}"
  -c "${USERNAME}:${PASSWORD}"
  -t titleFixed="AlmaLinux Web Terminal"
  -t fontSize=14
)

case "${TTYD_WRITABLE,,}" in
  false|0|no|off)
    echo "Input mode: readonly"
    ;;
  *)
    echo "Input mode: writable"
    ttyd_args+=(-W)
    ;;
esac

exec /usr/local/bin/ttyd "${ttyd_args[@]}" /bin/bash -l
