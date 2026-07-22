@echo off
title n8n update

docker info >nul 2>&1
if errorlevel 1 (
    echo [ES] Docker Desktop no esta corriendo. Abrelo y vuelve a intentar.
    echo [EN] Docker Desktop is not running. Open it and try again.
    pause
    exit /b 1
)

echo [ES] Descargando las ultimas versiones (tus workflows NO se pierden)...
echo [EN] Downloading the latest versions (your workflows are NOT lost)...
docker pull docker.n8n.io/n8nio/n8n
docker pull ngrok/ngrok:latest

echo.
echo [ES] Reiniciando con la nueva version...
echo [EN] Restarting with the new version...
call "%~dp0start-n8n.bat"
