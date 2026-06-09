#!/usr/bin/env bash

# Usage: git-fuckup.sh
#
# Creates a uniquely-named copy of the current Git branch as fuck-up
# insurance.

set -euo pipefail

branch=$(git rev-parse --abbrev-ref HEAD)
time=$(date +%s%3N)

git switch --create "fuckup_insurance_${time}_${branch}"
git switch -
