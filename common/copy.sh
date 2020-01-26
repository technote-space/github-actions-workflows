#!/bin/sh

set -e

readonly current=$(cd "$(dirname "$0")"; pwd)
readonly tmp="${current}"/.tmp

mkdir -p "${tmp}"
cp -f "${GITHUB_WORKSPACE}"/.github/workflows/sync-workflows.yml "${tmp}"/ > /dev/null 2>&1 || :
rm -f "${GITHUB_WORKSPACE}"/.github/workflows/*.yml

cp -f "${current}"/workflows/*.yml "${GITHUB_WORKSPACE}"/.github/workflows/
cp -f "${current}"/settings/*.yml "${GITHUB_WORKSPACE}"/.github/
cp -f "${tmp}"/sync-workflows.yml "${GITHUB_WORKSPACE}"/.github/workflows/sync-workflows.yml > /dev/null 2>&1 || :
rm -f "${GITHUB_WORKSPACE}"/.github/workflows/check_version.yml

rm -rdf "${tmp}"
