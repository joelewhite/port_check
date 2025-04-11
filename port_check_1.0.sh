#!/bin/bash

PORTS=(22 80 443 8080 8443)
UDP=false
LOGFILE=""
QUIET=false
CSVFILE=""

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m" # No Color

print_help() {
  cat << EOF
Usage: $0 --hosts "host1,host2" [--ports "22,80"] [--udp] [--log logfile] [--quiet]

Options:
  --hosts     Required. Space- or comma-separated list of hostnames or IPs.
  --ports     Optional. Ports to scan. Defaults: 22, 80, 443, 8080, 8443.
  --udp       Optional. Use UDP instead of TCP.
  --log       Optional. Append results to specified log file and generate CSV.
  --quiet     Optional. Suppress terminal output when used with --log.
  --help      Show this help message and exit.

Examples:
  $0 --hosts "example.com"
  $0 --hosts "example.com" --ports "53,161" --udp
  $0 --hosts "host1,host2" --log /var/log/port_check.log --quiet
EOF
  exit 0
}

parse_list() {
  echo "$1" | tr ', ' '\n' | sed '/^$/d'
}

log() {
  local msg="$1"
  local host="$2"
  local port="$3"
  local proto="$4"
  local status="$5"
  local ts="$(date '+%Y-%m-%d %H:%M:%S')"

  if ! $QUIET; then
    if [[ "$status" == "OPEN" ]]; then
      echo -e "${GREEN}$msg${NC}"
    elif [[ "$status" == "CLOSED" ]]; then
      echo -e "${RED}$msg${NC}"
    else
      echo "$msg"
    fi
  fi

  if [ -n "$LOGFILE" ]; then
    echo "[$ts] $msg" >> "$LOGFILE"
    echo "\"$ts\",\"$host\",\"$port\",\"$proto\",\"$status\"" >> "$CSVFILE"
  fi
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --hosts)
      shift
      HOSTS=$(parse_list "$1")
      ;;
    --ports)
      shift
      PORTS=($(parse_list "$1"))
      ;;
    --udp)
      UDP=true
      ;;
    --log)
      shift
      LOGFILE="$1"
      CSVFILE="${LOGFILE%.*}.csv"
      echo "\"Timestamp\",\"Host\",\"Port\",\"Protocol\",\"Status\"" > "$CSVFILE"
      ;;
    --quiet)
      QUIET=true
      ;;
    --help)
      print_help
      ;;
    *)
      echo "Unknown option: $1"
      echo "Try --help for usage."
      exit 1
      ;;
  esac
  shift
done

if [ -z "$HOSTS" ]; then
  echo "Error: --hosts is required."
  echo "Try --help for usage."
  exit 1
fi

for HOST in $HOSTS; do
  log "Scanning host: $HOST" "$HOST" "" "" ""
  for PORT in "${PORTS[@]}"; do
    if $UDP; then
      timeout 2 bash -c "echo > /dev/udp/$HOST/$PORT" 2>/dev/null
      if [ $? -eq 0 ]; then
        log "  UDP Port $PORT might be OPEN (no immediate failure)" "$HOST" "$PORT" "UDP" "OPEN"
      else
        log "  UDP Port $PORT is CLOSED or unreachable" "$HOST" "$PORT" "UDP" "CLOSED"
      fi
    else
      timeout 2 bash -c "echo > /dev/tcp/$HOST/$PORT" 2>/dev/null
      if [ $? -eq 0 ]; then
        log "  TCP Port $PORT is OPEN" "$HOST" "$PORT" "TCP" "OPEN"
      else
        log "  TCP Port $PORT is CLOSED" "$HOST" "$PORT" "TCP" "CLOSED"
      fi
    fi
  done
done
