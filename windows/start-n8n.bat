@echo off
setlocal
title n8n
set "CONFIG=%~dp0n8n-config.txt"

REM Check that Docker Desktop is running
docker info >nul 2>&1
if errorlevel 1 (
    echo.
    echo [ES] Docker Desktop no esta corriendo. Abre Docker Desktop, espera a que diga "Running" y vuelve a hacer doble clic en este archivo.
    echo [EN] Docker Desktop is not running. Open Docker Desktop, wait until it says "Running", then double-click this file again.
    echo.
    pause
    exit /b 1
)

if exist "%CONFIG%" goto loadconfig

REM One-time setup: ask for the ngrok authtoken and static domain
echo.
echo [ES] Configuracion inicial (solo la primera vez).
echo [EN] Initial setup (first time only).
echo.
echo   1) https://dashboard.ngrok.com/signup  (cuenta gratis / free account)
echo   2) https://dashboard.ngrok.com/get-started/your-authtoken  (copia tu authtoken / copy your authtoken)
echo   3) https://dashboard.ngrok.com/domains  (copia tu dev domain ya asignado / copy your pre-assigned dev domain)
echo.
set /p NGROK_AUTHTOKEN=ngrok authtoken:
set /p NGROK_DOMAIN=ngrok domain (ej/e.g. algo.ngrok-free.dev):
(
    echo NGROK_AUTHTOKEN=%NGROK_AUTHTOKEN%
    echo NGROK_DOMAIN=%NGROK_DOMAIN%
) > "%CONFIG%"

:loadconfig
for /f "usebackq tokens=1,* delims==" %%A in ("%CONFIG%") do set "%%A=%%B"
set "NGROK_DOMAIN=%NGROK_DOMAIN:https://=%"
if "%NGROK_DOMAIN:~-1%"=="/" set "NGROK_DOMAIN=%NGROK_DOMAIN:~0,-1%"

if "%NGROK_AUTHTOKEN%"=="" goto badconfig
if "%NGROK_DOMAIN%"=="" goto badconfig
goto run

:badconfig
echo [ES] El archivo n8n-config.txt esta incompleto. Borralo y vuelve a ejecutar este script.
echo [EN] The n8n-config.txt file is incomplete. Delete it and run this script again.
pause
exit /b 1

:run
docker network inspect n8n-net >nul 2>&1 || docker network create n8n-net >nul

echo.
echo [ES] Iniciando n8n (la primera vez descarga la imagen, puede tardar unos minutos)...
echo [EN] Starting n8n (the first run downloads the image, this can take a few minutes)...
echo.

REM Recreate both containers on every start: workflows live in the n8n_data
REM volume, so this is safe, and it picks up config changes automatically.
docker rm -f n8n >nul 2>&1
docker run -d --name n8n --network n8n-net -p 5678:5678 -v n8n_data:/home/node/.n8n -e WEBHOOK_URL=https://%NGROK_DOMAIN%/ docker.n8n.io/n8nio/n8n

docker rm -f n8n-ngrok >nul 2>&1
docker run -d --name n8n-ngrok --network n8n-net -e NGROK_AUTHTOKEN=%NGROK_AUTHTOKEN% ngrok/ngrok:latest http --url=https://%NGROK_DOMAIN% n8n:5678

echo.
echo [ES] Esperando a que n8n arranque...
echo [EN] Waiting for n8n to start...

set /a tries=0
:wait
curl -s -o nul http://localhost:5678 2>nul
if not errorlevel 1 goto ready
set /a tries+=1
if %tries% geq 90 goto ready
timeout /t 2 >nul
goto wait

:ready
REM If ngrok died right away, the authtoken or domain is wrong
timeout /t 2 >nul
docker ps -q -f name=n8n-ngrok -f status=running | findstr . >nul
if errorlevel 1 (
    echo.
    echo [ES] ATENCION: el tunel no arranco ^(authtoken o dominio incorrectos^).
    echo      Borra el archivo n8n-config.txt y vuelve a ejecutar este script.
    echo [EN] WARNING: the tunnel did not start ^(wrong authtoken or domain^).
    echo      Delete the n8n-config.txt file and run this script again.
)

echo.
echo [ES] Listo. Editor: http://localhost:5678 - Webhooks publicos: https://%NGROK_DOMAIN%
echo [EN] Done. Editor: http://localhost:5678 - Public webhooks: https://%NGROK_DOMAIN%
start http://localhost:5678
pause
