#!/bin/sh

set -e

readonly current=$(cd "$(dirname "$0")"; pwd)
readonly tmp="${current}"/.tmp

mkdir -p "${tmp}"
cp -f "${GITHUB_WORKSPACE}"/.github/workflows/sync-workflows.yml "${tmp}"/ > /dev/null 2>&1 || :
rm -f "${GITHUB_WORKSPACE}"/.github/workflows/*.yml

cp -f "${current}"/workflows/*.yml "${GITHUB_WORKSPACE}"/.github/workflows/
cp -f "${current}"/settings/*.yml "${GITHUB_WORKSPACE}"/.github/
cp -f "${current}"/settings/*.md "${GITHUB_WORKSPACE}"/.github/
cp -f "${current}"/settings/*.json "${GITHUB_WORKSPACE}"/.github/
cp -f "${tmp}"/sync-workflows.yml "${GITHUB_WORKSPACE}"/.github/workflows/sync-workflows.yml > /dev/null 2>&1 || :

# shellcheck disable=SC2016
MINUTE=$(echo "${GITHUB_REPOSITORY}" | md5sum | tr -d -c 0-9 | xargs -I{} echo {}123 | xargs -I{} bash -c 'echo $(({} % 60))')
# shellcheck disable=SC2016
HOUR=$(echo "${GITHUB_REPOSITORY}" | md5sum | tr -d -c 0-9 | xargs -I{} echo {}123 | xargs -I{} bash -c 'echo $(({} % 24))')
# shellcheck disable=SC2016
DATE=$(echo "${GITHUB_REPOSITORY}" | md5sum | tr -d -c 0-9 | xargs -I{} echo {}123 | xargs -I{} bash -c 'echo $(({} % 28 + 1))')
sed -i "s/cron:.\+$/cron: ${MINUTE} ${HOUR} ${DATE} * */" "${GITHUB_WORKSPACE}"/.github/workflows/broken-link-check.yml

rm -rdf "${tmp}"
