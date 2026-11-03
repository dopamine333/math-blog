#!/bin/bash
# Build the forest and publish it to the gh-pages branch.
set -euo pipefail

# Always run from the repository root.
cd "$(dirname "$0")"

# Clean the previous build.
rm -rf output

# Build the forest.
forester build forest.toml

# The actual website is inside output/math-blog/.
SITE_DIR="output/math-blog"

if [ ! -d "$SITE_DIR" ]; then
    echo "Error: $SITE_DIR does not exist. Build may have failed."
    exit 1
fi

# Get the GitHub remote.
REMOTE=$(git remote get-url origin)

# Create a temporary deployment directory.
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# Copy the contents of the generated site (not the parent directory).
cp -R "$SITE_DIR"/. "$TMP"/

# Tell GitHub Pages not to run Jekyll.
touch "$TMP/.nojekyll"

# Commit and push to gh-pages.
cd "$TMP"
git init -q -b gh-pages
git add -A
git commit -q -m "Deploy $(date -u +%Y-%m-%dT%H:%M:%SZ)"
git push -f "$REMOTE" gh-pages

echo "Deployment successful!"