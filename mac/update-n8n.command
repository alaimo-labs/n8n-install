#!/bin/bash
# n8n updater for macOS — double-click to update n8n to the latest version

DIR="$(cd "$(dirname "$0")" && pwd)"

if ! docker info >/dev/null 2>&1; then
    echo "[ES] Docker Desktop no está corriendo. Ábrelo y vuelve a intentar."
    echo "[EN] Docker Desktop is not running. Open it and try again."
    read -r -p "Press Enter to close..."
    exit 1
fi

echo "[ES] Descargando las últimas versiones (tus workflows NO se pierden)..."
echo "[EN] Downloading the latest versions (your workflows are NOT lost)..."
docker pull docker.n8n.io/n8nio/n8n
docker pull ngrok/ngrok:latest

echo ""
echo "[ES] Reiniciando con la nueva versión..."
echo "[EN] Restarting with the new version..."
exec "$DIR/start-n8n.command"
