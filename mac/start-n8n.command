#!/bin/bash
# n8n launcher for macOS — double-click to start n8n + public webhook tunnel (ngrok)

DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$DIR/n8n-config.txt"

if ! docker info >/dev/null 2>&1; then
    echo ""
    echo "[ES] Docker Desktop no está corriendo. Abre Docker Desktop, espera a que diga \"Running\" y vuelve a hacer doble clic en este archivo."
    echo "[EN] Docker Desktop is not running. Open Docker Desktop, wait until it says \"Running\", then double-click this file again."
    echo ""
    read -r -p "Press Enter to close..."
    exit 1
fi

# One-time setup: ask for the ngrok authtoken and static domain
if [ ! -f "$CONFIG" ]; then
    echo ""
    echo "[ES] Configuración inicial (solo la primera vez)."
    echo "[EN] Initial setup (first time only)."
    echo ""
    echo "  1) https://dashboard.ngrok.com/signup  (cuenta gratis / free account)"
    echo "  2) https://dashboard.ngrok.com/get-started/your-authtoken  (copia tu authtoken / copy your authtoken)"
    echo "  3) https://dashboard.ngrok.com/domains  (crea tu dominio gratis / claim your free domain)"
    echo ""
    read -r -p "ngrok authtoken: " NGROK_AUTHTOKEN
    read -r -p "ngrok domain (ej/e.g. algo.ngrok-free.app): " NGROK_DOMAIN
    printf 'NGROK_AUTHTOKEN=%s\nNGROK_DOMAIN=%s\n' "$NGROK_AUTHTOKEN" "$NGROK_DOMAIN" > "$CONFIG"
fi

# Load config (KEY=VALUE lines)
NGROK_AUTHTOKEN="$(grep '^NGROK_AUTHTOKEN=' "$CONFIG" | cut -d= -f2-)"
NGROK_DOMAIN="$(grep '^NGROK_DOMAIN=' "$CONFIG" | cut -d= -f2-)"
NGROK_DOMAIN="${NGROK_DOMAIN#https://}"
NGROK_DOMAIN="${NGROK_DOMAIN%/}"

if [ -z "$NGROK_AUTHTOKEN" ] || [ -z "$NGROK_DOMAIN" ]; then
    echo "[ES] El archivo n8n-config.txt está incompleto. Bórralo y vuelve a ejecutar este script."
    echo "[EN] The n8n-config.txt file is incomplete. Delete it and run this script again."
    read -r -p "Press Enter to close..."
    exit 1
fi

docker network inspect n8n-net >/dev/null 2>&1 || docker network create n8n-net >/dev/null

echo ""
echo "[ES] Iniciando n8n (la primera vez descarga la imagen, puede tardar unos minutos)..."
echo "[EN] Starting n8n (the first run downloads the image, this can take a few minutes)..."
echo ""

# Recreate both containers on every start: workflows live in the n8n_data
# volume, so this is safe, and it picks up config changes automatically.
docker rm -f n8n >/dev/null 2>&1
docker run -d --name n8n --network n8n-net -p 5678:5678 \
    -v n8n_data:/home/node/.n8n \
    -e WEBHOOK_URL="https://$NGROK_DOMAIN/" \
    docker.n8n.io/n8nio/n8n

docker rm -f n8n-ngrok >/dev/null 2>&1
docker run -d --name n8n-ngrok --network n8n-net \
    -e NGROK_AUTHTOKEN="$NGROK_AUTHTOKEN" \
    ngrok/ngrok:latest http --url="https://$NGROK_DOMAIN" n8n:5678

echo ""
echo "[ES] Esperando a que n8n arranque..."
echo "[EN] Waiting for n8n to start..."

tries=0
until curl -s -o /dev/null http://localhost:5678; do
    tries=$((tries + 1))
    if [ "$tries" -ge 90 ]; then
        break
    fi
    sleep 2
done

# If ngrok died right away, the authtoken or domain is wrong
sleep 2
if [ -z "$(docker ps -q -f name=n8n-ngrok -f status=running)" ]; then
    echo ""
    echo "[ES] ATENCIÓN: el túnel no arrancó (authtoken o dominio incorrectos)."
    echo "     Borra el archivo n8n-config.txt y vuelve a ejecutar este script."
    echo "[EN] WARNING: the tunnel did not start (wrong authtoken or domain)."
    echo "     Delete the n8n-config.txt file and run this script again."
fi

echo ""
echo "[ES] Listo. Editor: http://localhost:5678 — Webhooks públicos: https://$NGROK_DOMAIN"
echo "[EN] Done. Editor: http://localhost:5678 — Public webhooks: https://$NGROK_DOMAIN"
open http://localhost:5678
