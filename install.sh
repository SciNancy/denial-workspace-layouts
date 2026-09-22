#!/bin/bash
# install.sh — apply workspace-layouts patch to Denial and build
set -euo pipefail

PATCH_URL="${PATCH_URL:-https://github.com/SciNancy/denial-workspace-layouts/raw/main/workspace-layouts.patch}"
DENIAL_REPO="${DENIAL_REPO:-https://github.com/denialwm/denial.git}"
# The patch is generated against this release; a newer main would not apply.
DENIAL_TAG="${DENIAL_TAG:-v0.4.4}"
WORKDIR="${WORKDIR:-$(mktemp -d)}"

echo "==> Cloning Denial ($DENIAL_TAG)..."
git clone --depth 1 --branch "$DENIAL_TAG" "$DENIAL_REPO" "$WORKDIR/denial"
cd "$WORKDIR/denial"

echo "==> Applying patch..."
curl -L "$PATCH_URL" | git apply -

echo "==> Building Dart AOT bundle..."
denial-ui prepare-profile

echo "==> Activating..."
denialctl ui profile

echo ""
echo "Done! Press win+I to see the workspaces card."
echo ""
echo "For persistence across reboots, add to your shell rc:"
echo '  denial-branch() {'
echo '    DENIAL_FLUTTER_BUNDLE="$HOME/.cache/denial/ui-development/profile/bundle" \'
echo '      exec /usr/bin/denial-session "$@"'
echo '  }'
echo "Then launch with: denial-branch"
