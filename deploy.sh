#!/usr/bin/env bash
set -euo pipefail

commit=$(git rev-parse HEAD)
git checkout --track origin/gh-pages
cp -Rf public/* .
rm -rf public
git commit -a -m "Depolyment of ${commit}"
git push origin HEAD
