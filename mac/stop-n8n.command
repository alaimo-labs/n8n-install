#!/bin/bash
# n8n stopper for macOS — double-click to stop n8n and the tunnel

stopped=0
docker stop n8n >/dev/null 2>&1 && stopped=1
docker stop n8n-ngrok >/dev/null 2>&1

if [ "$stopped" -eq 1 ]; then
    echo "[ES] n8n detenido. Tus workflows quedan guardados."
    echo "[EN] n8n stopped. Your workflows are saved."
else
    echo "[ES] n8n no estaba corriendo."
    echo "[EN] n8n was not running."
fi
read -r -p "Press Enter to close..."
