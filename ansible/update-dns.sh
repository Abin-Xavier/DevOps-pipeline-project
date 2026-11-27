#!/usr/bin/env bash
# Usage: ./update-dns.sh <server-ip>
set -euo pipefail

[ $# -eq 1 ] || { echo "Usage: $0 <server-ip>"; exit 1; }
source ~/.duckdns

result=$(curl -s "https://www.duckdns.org/update?domains=${DDNS_NAME}&token=${DDNS_TOKEN}&ip=$1")
echo "DuckDNS update for ${DDNS_NAME}.duckdns.org -> $1: ${result}"
[ "$result" = "OK" ]
