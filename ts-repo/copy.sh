#!/bin/sh

set -e

if [ $# -lt 1 ]; then
  echo "usage: $0 <release type>"
  exit 1
fi

current=$(cd "$(dirname "$0")"; pwd)
common=$(cd "$(dirname "$0")"/../common; pwd)
tmp="${current}"/.tmp

mkdir -p "${tmp}"
cp -f "${GITHUB_WORKSPACE}"/.github/workflows/sync-workflows.yml "${tmp}"/ > /dev/null 2>&1 || :
rm -f "${GITHUB_WORKSPACE}"/.github/workflows/*.yml

cp -f "${common}"/workflows/*.yml "${GITHUB_WORKSPACE}"/.github/workflows/
cp -f "${common}"/settings/*.yml "${GITHUB_WORKSPACE}"/.github/
cp -f "${current}"/*.yml "${GITHUB_WORKSPACE}"/.github/workflows/
cp -f "${tmp}"/sync-workflows.yml "${GITHUB_WORKSPACE}"/.github/workflows/sync-workflows.yml > /dev/null 2>&1 || :
cp -f "${current}"/release/"${1}".yml "${GITHUB_WORKSPACE}"/.github/workflows/release.yml

rm -rdf "${tmp}"