# shellcheck shell=sh

case "$-" in
  *i*) ;;
  *) return 0 ;;
esac

if [ -n "${ALMALINUX_WELCOME_SHOWN:-}" ]; then
  return 0
fi

case "${SHOW_WELCOME:-true}" in
  false|FALSE|0|no|NO|off|OFF)
    return 0
    ;;
esac

export ALMALINUX_WELCOME_SHOWN=1
welcome_command="${WELCOME_COMMAND:-almalinux-welcome}"

if command -v "${welcome_command}" >/dev/null 2>&1; then
  "${welcome_command}" || true
fi
