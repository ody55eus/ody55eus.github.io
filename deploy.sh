#!/usr/bin/env bash
set -euo pipefail

hash = $(git rev-parse HEAD)
git checkout gh-pages
cp -Rf public/* .
rm -rf public
git commit -a -m "Depolyment of ${hash}"
git push
