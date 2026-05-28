#!/usr/bin/env bash
set -u

red="$(printf '\033[1;31m')"
green="$(printf '\033[1;32m')"
yellow="$(printf '\033[1;33m')"
blue="$(printf '\033[1;34m')"
magenta="$(printf '\033[1;35m')"
cyan="$(printf '\033[1;36m')"
white="$(printf '\033[1;37m')"
reset="$(printf '\033[0m')"

os_name="AlmaLinux"
if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  source /etc/os-release
  os_name="${PRETTY_NAME:-${NAME:-AlmaLinux}}"
fi

host_name="$(hostname 2>/dev/null || printf unknown)"
kernel="$(uname -r 2>/dev/null || printf unknown)"
uptime_text="$(uptime -p 2>/dev/null | sed 's/^up //' || printf unknown)"
package_count="$(rpm -qa 2>/dev/null | wc -l | tr -d ' ')"
shell_name="$(basename "${SHELL:-/bin/bash}")"
shell_version="$(bash --version 2>/dev/null | awk 'NR==1 {print $4}')"
cpu_name="$(awk -F': ' '/model name/ {print $2; exit}' /proc/cpuinfo 2>/dev/null)"
cpu_name="${cpu_name:-$(awk -F': ' '/Hardware/ {print $2; exit}' /proc/cpuinfo 2>/dev/null)}"
cpu_name="${cpu_name:-unknown}"
memory_used="$(awk '/MemTotal/ {total=$2} /MemAvailable/ {available=$2} END {if (total > 0) printf "%.0fMiB / %.0fMiB", (total-available)/1024, total/1024; else print "unknown"}' /proc/meminfo 2>/dev/null)"
disk_used="$(df -h "${WORKSPACE_DIR:-/root/workspace}" 2>/dev/null | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}')"
disk_used="${disk_used:-unknown}"

logo=(
"          .:cccccccccccc:."
"       .:cccccccccccccccccc:."
"     .:cccccccccccccccccccccc:."
"    :cccccccccccccccccccccccc:"
"   :cccccccccccccccccccccccccc:"
"  :ccccccccc:oooooooo:ccccccccc:"
" :cccccccc:oooooooooo:cccccccc:"
" :ccccccc:oooooooooooo:ccccccc:"
" :cccccc:oooo:cccc:oooo:cccccc:"
" :ccccc:oooo:cccccc:oooo:ccccc:"
"  :cccc:oooo:cccccccc:oooo:cccc:"
"   :ccc:oooooooooooooooo:ccc:"
"    :cc:oooooooooooooooooo:cc:"
"     .:oooooooooooooooooooo:."
"       .:cccccccccccccccccc:."
"          .:cccccccccccc:."
)

info=(
"${red}root@${host_name}${reset}"
"${red}----------------${reset}"
"${red}OS:${reset} ${os_name}"
"${red}Host:${reset} Railway Container"
"${red}Kernel:${reset} ${kernel}"
"${red}Uptime:${reset} ${uptime_text}"
"${red}Packages:${reset} ${package_count} (rpm)"
"${red}Shell:${reset} ${shell_name} ${shell_version}"
"${red}Terminal:${reset} ttyd"
"${red}CPU:${reset} ${cpu_name}"
"${red}Memory:${reset} ${memory_used}"
"${red}Disk:${reset} ${disk_used}"
""
"${red}   ${green}   ${yellow}   ${blue}   ${magenta}   ${cyan}   ${white}   ${reset}"
"${red}███${green}███${yellow}███${blue}███${magenta}███${cyan}███${white}███${reset}"
)

max_lines="${#logo[@]}"
if (( ${#info[@]} > max_lines )); then
  max_lines="${#info[@]}"
fi

printf '\n'
for ((i = 0; i < max_lines; i++)); do
  printf '%b%-36s%b  %b\n' "${red}" "${logo[$i]:-}" "${reset}" "${info[$i]:-}"
done
printf '\n'
