#!/bin/bash
set -e

if [ -z "$DISPLAY" ]; then
    mkdir -p /tmp/.X11-unix 2>/dev/null || true
    Xvfb :99 -screen 0 1280x900x24 -nolisten tcp >/dev/null 2>&1 &
    export DISPLAY=:99
    sleep 0.5
fi

# Ensure XDG_CACHE_HOME is exported for non-root user
export XDG_CACHE_HOME=/opt/camoufox-cache

# Fallback symlinks
mkdir -p "$HOME/.cache" 2>/dev/null || true
ln -sf /opt/camoufox-cache/camoufox "$HOME/.cache/camoufox" 2>/dev/null || true
mkdir -p "$HOME/.camoufox" 2>/dev/null || true

exec python3 -m app
