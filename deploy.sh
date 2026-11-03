#!/bin/bash
# Build the forest and publish output/ to the gh-pages branch,
# which GitHub Pages serves. Run it whenever you want to update the site.
set -euo pipefail

forester build

REMOTE=$(git remote get-url origin)
TMP=$(mktemp -d)

cp -R output/. "$TMP"/
touch "$TMP/.nojekyll"      # stop GitHub from running Jekyll on the files

cd "$TMP"
git init -q -b gh-pages
git add -A
git commit -q -m "Deploy $(date -u +%Y-%m-%dT%H:%M:%SZ)"
git push -f "$REMOTE" gh-pages   # replaces the previous deploy
rm -rf "$TMP"