#!/usr/bin/env bash
# Development install script for Kaku
# Creates versioned builds with symlinks for easy local development
#
# Usage:
#   ./scripts/dev-install.sh          # Build debug and install
#   ./scripts/dev-install.sh release  # Build release and install
#   ./scripts/dev-install.sh --open   # Build, install, and open app

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

PROFILE="${1:-debug}"
OPEN_APP=0

for arg in "$@"; do
    case "$arg" in
        --open) OPEN_APP=1 ;;
        release) PROFILE="release" ;;
        debug) PROFILE="debug" ;;
    esac
done

# Installation paths
INSTALL_BASE="/usr/local/Cellar/kaku"
SYMLINK_PATH="/usr/local/bin/kaku"
APP_INSTALL_BASE="/Applications"

# Generate version with timestamp
VERSION=$(grep '^version =' kaku/Cargo.toml | head -n 1 | cut -d '"' -f2)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
VERSIONED_NAME="kaku-${VERSION}-${TIMESTAMP}"

echo "=== Kaku Development Install ==="
echo "Profile: $PROFILE"
echo "Version: $VERSION"
echo "Build ID: $VERSIONED_NAME"
echo ""

# Build
echo "[1/4] Building..."
if [[ "$PROFILE" == "release" ]]; then
    PROFILE=release ./scripts/build.sh --app-only --native-arch
else
    PROFILE=debug ./scripts/build.sh --app-only --native-arch
fi

# Install CLI binary
echo "[2/4] Installing CLI binary..."
if [[ "$PROFILE" == "release" ]]; then
    BIN_SOURCE="target/$(rustc -vV | grep host | cut -d' ' -f2)/release/kaku"
else
    BIN_SOURCE="target/$(rustc -vV | grep host | cut -d' ' -f2)/debug/kaku"
fi

VERSIONED_BIN_PATH="$INSTALL_BASE/$VERSIONED_NAME"

sudo mkdir -p "$INSTALL_BASE"
sudo cp "$BIN_SOURCE" "$VERSIONED_BIN_PATH"
sudo chmod +x "$VERSIONED_BIN_PATH"

# Update symlink
sudo rm -f "$SYMLINK_PATH"
sudo ln -s "$VERSIONED_BIN_PATH" "$SYMLINK_PATH"

echo "CLI installed: $SYMLINK_PATH -> $VERSIONED_BIN_PATH"

# Install App bundle
echo "[3/4] Installing App bundle..."
APP_SOURCE="dist/Kaku.app"
APP_VERSIONED_NAME="Kaku-${VERSION}-${TIMESTAMP}.app"
APP_VERSIONED_PATH="$APP_INSTALL_BASE/$APP_VERSIONED_NAME"
APP_SYMLINK_PATH="$APP_INSTALL_BASE/Kaku-dev.app"

# Copy versioned app
sudo rm -rf "$APP_VERSIONED_PATH"
sudo cp -R "$APP_SOURCE" "$APP_VERSIONED_PATH"

# Update app symlink
sudo rm -rf "$APP_SYMLINK_PATH"
sudo ln -s "$APP_VERSIONED_PATH" "$APP_SYMLINK_PATH"

echo "App installed: $APP_SYMLINK_PATH -> $APP_VERSIONED_PATH"

# Cleanup old versions (keep last 3)
echo "[4/4] Cleaning up old versions..."
cleanup_old_versions() {
    local base_path="$1"
    local pattern="$2"
    local keep_count="${3:-3}"

    if [[ -d "$base_path" ]]; then
        # List matching items, sort by time (oldest first), remove all but last N
        local items
        items=$(ls -1t "$base_path" 2>/dev/null | grep -E "$pattern" || true)
        local count
        count=$(echo "$items" | grep -c . || echo 0)

        if [[ $count -gt $keep_count ]]; then
            local to_remove
            to_remove=$(echo "$items" | tail -n +$((keep_count + 1)))
            echo "$to_remove" | while read -r item; do
                if [[ -n "$item" ]]; then
                    echo "  Removing old: $item"
                    sudo rm -rf "$base_path/$item"
                fi
            done
        fi
    fi
}

cleanup_old_versions "$INSTALL_BASE" "^kaku-" 3
cleanup_old_versions "$APP_INSTALL_BASE" "^Kaku-.*\.app$" 3

echo ""
echo "=== Installation Complete ==="
echo "CLI:  $SYMLINK_PATH"
echo "App:  $APP_SYMLINK_PATH"
echo ""
echo "To configure cursor_height, add to your ~/.config/kaku/kaku.lua:"
echo "  return {"
echo "    cursor_height = 0.8,  -- 0.0 < value <= 1.0"
echo "  }"
echo ""

if [[ "$OPEN_APP" == "1" ]]; then
    echo "Opening app..."
    open "$APP_SYMLINK_PATH"
fi
