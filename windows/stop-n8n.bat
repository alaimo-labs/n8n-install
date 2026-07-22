@echo off
title n8n

docker stop n8n >nul 2>&1
if errorlevel 1 (
    docker stop n8n-ngrok >nul 2>&1
    echo [ES] n8n no estaba corriendo.
    echo [EN] n8n was not running.
) else (
    docker stop n8n-ngrok >nul 2>&1
    echo [ES] n8n detenido. Tus workflows quedan guardados.
    echo [EN] n8n stopped. Your workflows are saved.
)
pause
