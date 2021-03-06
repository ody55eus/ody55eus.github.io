#!/usr/bin/env bash
set -euo pipefail

commit=$(git rev-parse HEAD)
git branch -u origin/gh-pages gh-pages
git fetch origin gh-pages
echo $(git branch -v)
git checkout gh-pages
cp -Rf public/* .
rm -rf public
git commit -a -m "Depolyment of ${commit}"
git push origin HEAD
