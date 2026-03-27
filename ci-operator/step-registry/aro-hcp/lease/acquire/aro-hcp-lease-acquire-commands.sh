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

echo "Acquiring lease: ${LEASE1_TYPE} (count: ${LEASE1_COUNT})"
leases_handle=$(lease__acquire --type="${LEASE1_TYPE}" --count="${LEASE1_COUNT}" --scope=test)
if [[ -n "${LEASE1_FILE}" ]]; then
    lease__cat --handle="$leases_handle" --format=csv >> "${SHARED_DIR}/${LEASE1_FILE}"
    echo "Wrote lease names to ${SHARED_DIR}/${LEASE1_FILE}"
fi

if [[ -n "${LEASE2_TYPE}" ]]; then
    echo "Acquiring lease: ${LEASE2_TYPE} (count: ${LEASE2_COUNT})"
    leases_handle=$(lease__acquire --type="${LEASE2_TYPE}" --count="${LEASE2_COUNT}" --scope=test)
    if [[ -n "${LEASE2_FILE}" ]]; then
        lease__cat --handle="$leases_handle" --format=csv >> "${SHARED_DIR}/${LEASE2_FILE}"
        echo "Wrote lease names to ${SHARED_DIR}/${LEASE2_FILE}"
    fi
fi

echo "Leases acquired"
