#!/bin/sh

set -e

readonly current=$(cd "$(dirname "$0")"; pwd)
readonly common=$(cd "$(dirname "$0")"/../common; pwd)
readonly tmp="${current}"/.tmp

mkdir -p "${tmp}"
cp -f "${GITHUB_WORKSPACE}"/.github/workflows/sync-workflows.yml "${tmp}"/ > /dev/null 2>&1 || :
rm -f "${GITHUB_WORKSPACE}"/.github/workflows/*.yml

cp -f "${common}"/workflows/*.yml "${GITHUB_WORKSPACE}"/.github/workflows/
cp -f "${common}"/settings/*.yml "${GITHUB_WORKSPACE}"/.github/
cp -f "${common}"/settings/*.md "${GITHUB_WORKSPACE}"/.github/
cp -f "${common}"/settings/*.json "${GITHUB_WORKSPACE}"/.github/
cp -f "${current}"/*.yml "${GITHUB_WORKSPACE}"/.github/workflows/
cp -f "${tmp}"/sync-workflows.yml "${GITHUB_WORKSPACE}"/.github/workflows/sync-workflows.yml > /dev/null 2>&1 || :

# shellcheck disable=SC2039
find "${GITHUB_WORKSPACE}"/.github/workflows -maxdepth 1 -type f -name '*.yml' -print0 | xargs -0 readlink -f | while read -r file; do sed -i "s/uses: \(${GITHUB_REPOSITORY/\//\\/}\)@.\+$/uses: \1@gh-actions/" "$file"; done
rm -f "${GITHUB_WORKSPACE}"/.github/workflows/gh-releases.yml

# shellcheck disable=SC2016
MINUTE=$(echo "${GITHUB_REPOSITORY}" | md5sum | tr -d -c 0-9 | xargs -I{} echo {}123 | xargs -I{} bash -c 'echo $(({} % 60))')
# shellcheck disable=SC2016
HOUR=$(echo "${GITHUB_REPOSITORY}" | md5sum | tr -d -c 0-9 | xargs -I{} echo {}123 | xargs -I{} bash -c 'echo $(({} % 24))')
# shellcheck disable=SC2016
DATE=$(echo "${GITHUB_REPOSITORY}" | md5sum | tr -d -c 0-9 | xargs -I{} echo {}123 | xargs -I{} bash -c 'echo $(({} % 28 + 1))')
sed -i "s/cron:.\+$/cron: ${MINUTE} ${HOUR} ${DATE} * */" "${GITHUB_WORKSPACE}"/.github/workflows/broken-link-check.yml

rm -rdf "${tmp}"
