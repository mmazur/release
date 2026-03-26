#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

if [[ -z "${LEASE_PROXY_SERVER_URL:-}" ]]; then
    echo "ERROR: LEASE_PROXY_SERVER_URL is not set, lease proxy is not available"
    exit 1
fi

# shellcheck disable=SC1090
source "$LEASE_PROXY_CLIENT_SH"

extract_lease_names() {
    local lease_type="$1"
    local out="${SHARED_DIR}/leases-${lease_type}"
    grep "^${lease_type}-" "${SHARED_DIR}/leases" > "$out" || true
    if [[ -s "$out" ]]; then
        echo "Wrote lease names for ${lease_type} to ${out}"
    else
        rm -f "$out"
        echo "No matching lease names for ${lease_type} in ${SHARED_DIR}/leases, removed ${out}"
    fi
}

echo "Acquiring lease: ${LEASE1_TYPE} (count: ${LEASE1_COUNT})"
lease__acquire --type="${LEASE1_TYPE}" --count="${LEASE1_COUNT}" --scope=test
extract_lease_names "${LEASE1_TYPE}"

if [[ -n "${LEASE2_TYPE}" ]]; then
    echo "Acquiring lease: ${LEASE2_TYPE} (count: ${LEASE2_COUNT})"
    lease__acquire --type="${LEASE2_TYPE}" --count="${LEASE2_COUNT}" --scope=test
    extract_lease_names "${LEASE2_TYPE}"
fi

echo "Leases acquired"
