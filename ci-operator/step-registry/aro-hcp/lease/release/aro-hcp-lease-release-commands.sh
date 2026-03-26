#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

# shellcheck disable=SC1090
source "$LEASE_PROXY_CLIENT_SH"

echo "Releasing leases"
lease__release --scope=test || echo "Lease release failed or no leases to release"
echo "Done"
