#!/usr/bin/env bash
set -euo pipefail

PLIST_NAME="gnu.emacs.daemon"
PLIST_SRC="$(cd "$(dirname "$0")" && pwd)/../etc/${PLIST_NAME}.plist"
PLIST_DST="$HOME/Library/LaunchAgents/${PLIST_NAME}.plist"
EMACS_BIN="/opt/homebrew/bin/emacs"

# Detect Intel Mac fallback
if [[ ! -x "$EMACS_BIN" ]] && [[ -x "/usr/local/bin/emacs" ]]; then
    EMACS_BIN="/usr/local/bin/emacs"
fi

if [[ ! -x "$EMACS_BIN" ]]; then
    echo "Error: Emacs not found at $EMACS_BIN"
    echo "Install with: brew install emacs-plus@30 --with-native-comp"
    exit 1
fi

echo "Using Emacs: $EMACS_BIN"
echo "  Version: $($EMACS_BIN --version | head -1)"

# Stop existing service if running
if launchctl list "$PLIST_NAME" &>/dev/null; then
    echo "Stopping existing Emacs daemon..."
    launchctl unload "$PLIST_DST" 2>/dev/null || true
fi

# Patch plist with correct Emacs path
mkdir -p "$HOME/Library/LaunchAgents"
sed "s|/opt/homebrew/bin/emacs|${EMACS_BIN}|g" "$PLIST_SRC" > "$PLIST_DST"

# Load the service
launchctl load -w "$PLIST_DST"

echo ""
echo "Emacs daemon service installed and started."
echo ""
echo "Usage:"
echo "  emacsclient -c          # Open GUI frame"
echo "  emacsclient -t          # Open in terminal"
echo "  emacsclient -e '(...)' # Eval expression"
echo ""
echo "Management:"
echo "  launchctl stop $PLIST_NAME    # Stop daemon"
echo "  launchctl start $PLIST_NAME   # Start daemon"
echo "  launchctl unload $PLIST_DST   # Uninstall service"
