# n8n Local, gratis y con webhooks / n8n locally, free, with webhooks

Este repositorio contiene scripts para instalar y ejecutar **n8n Local gratuitamente en tu computadora**, incluyendo acceso a webhooks desde internet mediante ngrok.

Esta opción está pensada como una **alternativa gratuita a n8n Cloud para personas con background técnico** que se sientan cómodas instalando software y resolviendo eventuales inconvenientes de configuración en su propio equipo.

Los scripts simplifican considerablemente el proceso estándar de instalación, pero n8n Local depende de componentes como Docker, la configuración del sistema operativo, virtualización, permisos y características particulares de cada computadora.

> **Importante:** Alaimo Labs proporciona estos scripts y este tutorial como un recurso opcional para facilitar la instalación de n8n Local. Debido a las diferencias entre equipos y configuraciones, **no nos es posible brindar soporte técnico individual para resolver problemas relacionados con Docker, virtualización, sistema operativo, redes u otros componentes del entorno local**.
>
> Si no tienes background técnico o prefieres evitar este tipo de configuración y troubleshooting, **recomendamos utilizar n8n Cloud**.

> **Nota:** n8n discontinuó su servicio de túnel propio (`--tunnel`) en 2026, por eso estos scripts utilizan ngrok para exponer los webhooks.

---

## English

This repository contains scripts to install and run **n8n locally on your computer for free**, including internet-accessible webhooks through ngrok.

This setup is intended as a **free alternative to n8n Cloud for users with a technical background** who are comfortable installing software and troubleshooting potential configuration issues on their own computer.

The scripts considerably simplify the standard installation process, but running n8n locally depends on components such as Docker, operating system configuration, virtualization, permissions, and other machine-specific settings.

> **Important:** Alaimo Labs provides these scripts and this tutorial as an optional resource to make the local installation of n8n easier. Because every computer and environment can be configured differently, **we are unable to provide individual technical support for issues related to Docker, virtualization, operating systems, networking, or other local environment components**.
>
> If you don't have a technical background or would rather avoid installation and troubleshooting, **we recommend using n8n Cloud**.

> **Note:** n8n discontinued its built-in tunnel service (`--tunnel`) in 2026, which is why these scripts use ngrok to expose webhooks.


---

## Español

### Cómo descargar

1. Descarga todo desde este link: **<https://github.com/alaimo-labs/n8n-install/archive/refs/heads/main.zip>**
2. Descomprime el archivo (doble clic en el ZIP descargado).
3. Guarda la carpeta en un lugar fijo (por ejemplo, Documentos) — ahí van a quedar los scripts y tu configuración.

No necesitas cuenta de GitHub ni saber usar git: el link descarga todo directamente.

### Requisitos (una sola vez)

**1. Docker Desktop**

1. Descarga Docker Desktop desde <https://www.docker.com/products/docker-desktop/> y ejecuta el instalador (siguiente → siguiente → finalizar).
2. **Windows**: si el instalador te pide habilitar WSL 2, acepta. Al terminar la instalación, **reinicia la computadora** (aunque no te lo pida — Windows lo necesita para reconocer Docker).
3. Abre Docker Desktop y espera a que diga **Engine running** (abajo a la izquierda). No necesitas crear cuenta: si te pide iniciar sesión, puedes saltarlo.

**2. Cuenta gratis de ngrok** (para que los webhooks funcionen desde internet)

1. Crea una cuenta en <https://dashboard.ngrok.com/signup>.
2. Copia tu **authtoken**: <https://dashboard.ngrok.com/get-started/your-authtoken>.
3. Copia tu **dominio gratis**: <https://dashboard.ngrok.com/domains>. ngrok ya le asignó a tu cuenta un "dev domain" (algo como `nombre-raro-setenta.ngrok-free.dev`) — no necesitas crear nada, solo copiarlo con el ícono de copiar. Es uno por cuenta y no cambia nunca.

Ten a mano el authtoken y el dominio: el script te los pedirá la primera vez y los guardará en `n8n-config.txt` (junto al script).

### Iniciar n8n

- **Windows**: doble clic en `windows/start-n8n.bat`.
- **Mac**: doble clic en `mac/start-n8n.command`.
  - La primera vez, macOS puede bloquearlo por ser un archivo descargado. Haz clic derecho sobre el archivo → **Abrir** → **Abrir** (solo hace falta una vez).

La primera vez pide el authtoken y el dominio de ngrok, y descarga n8n (unos minutos). Al terminar, se abre el navegador en `https://tu-dominio.ngrok-free.dev`, donde creas tu usuario local y ya puedes armar workflows.

> **Importante**: usa siempre el editor desde tu dominio de ngrok (no desde `localhost:5678`). Si usas `localhost`, los formularios (Form Trigger) no se abren al ejecutar el workflow, porque el navegador bloquea la comunicación entre los dos dominios (CORS). La primera vez que abras tu dominio, ngrok muestra una página de aviso: haz clic en **Visit Site** (solo una vez por navegador).

### Webhooks (por ejemplo, desde Lovable)

Los webhooks que copies del editor de n8n ya salen con tu dominio público (`https://tu-dominio.ngrok-free.dev/webhook/...`): pégalos directo en Lovable u otro servicio. El dominio no cambia entre reinicios.

Tres cosas importantes:

- Los webhooks solo responden **mientras tu computadora está encendida y n8n corriendo**.
- **Si Lovable llama al webhook desde el navegador** (código frontend), el plan gratis de ngrok intercepta la primera visita de navegador con una página de aviso. Solución: en el código de Lovable, agrega el header `ngrok-skip-browser-warning: true` a la llamada `fetch`. Las llamadas desde backend (edge functions, APIs, formularios de servidores) no tienen este problema.
- Esto es para **aprender y prototipar**. Para algo en producción, usa n8n en un servidor (VPS o n8n Cloud).

### Detener y actualizar

- Detener: doble clic en `stop-n8n`. Tus workflows quedan guardados.
- Actualizar n8n: doble clic en `update-n8n`. Tus workflows **no** se pierden (viven en un volumen de Docker llamado `n8n_data`).

### Si algo no funciona

| Síntoma                                                                        | Solución                                                                                                                                                                                                                    |
| ------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "Docker Desktop no está corriendo"                                             | Abre Docker Desktop, espera al estado **Engine running** y vuelve a intentar.                                                                                                                                               |
| Docker Desktop dice "Engine running" pero el script dice que no está corriendo | Reinicia la computadora (Windows lo necesita después de instalar Docker Desktop) y vuelve a intentar.                                                                                                                       |
| No sé dónde hacer doble clic                                                   | El doble clic es en tu computadora, no en la página de GitHub: descarga el ZIP (link arriba), descomprímelo, abre la carpeta y entra a `windows` o `mac` según tu sistema.                                                  |
| "El túnel no arrancó (authtoken o dominio incorrectos)"                        | Borra el archivo `n8n-config.txt` que está junto al script y vuelve a ejecutar `start-n8n` con los datos correctos.                                                                                                         |
| El navegador muestra error al abrir                                            | Espera 30 segundos y recarga la página; la primera vez tarda más.                                                                                                                                                           |
| n8n no carga después de reiniciar la compu                                     | Doble clic en `start-n8n` otra vez.                                                                                                                                                                                         |
| Un webhook no responde desde afuera                                            | Verifica que la compu esté encendida, n8n corriendo, y que la URL empiece con `https://tu-dominio.ngrok-free.dev`. Si lo llamas desde código frontend, agrega el header `ngrok-skip-browser-warning`.                       |
| Al ejecutar un workflow con formulario, el formulario no se abre               | Usa el editor desde `https://tu-dominio.ngrok-free.dev` (no desde `localhost`). Si la pestaña quedó abierta de antes de un reinicio, recárgala con Cmd+Shift+R (Mac) o Ctrl+Shift+R (Windows).                              |
| El formulario dice "isn't listening yet" o "Problem submitting response"       | El modo de prueba expira a los ~2 minutos: vuelve a hacer clic en "Ejecutar workflow" y envía el formulario enseguida. Para una URL permanente, publica el workflow (**Publish**) y usa la URL de producción (`/form/...`). |
| Error `X-Forwarded-For` / `trust proxy` en los logs                            | Tu script es de una versión vieja: descarga la versión actual de `start-n8n` y ejecútala de nuevo.                                                                                                                          |
| `ERR_SSL_PROTOCOL_ERROR` o página de "sitio bloqueado" al abrir tu dominio     | La función de seguridad de tu router o proveedor de internet está bloqueando el dominio de ngrok (pasa con Spectrum "Advanced Security" y similares). Prueba con datos móviles para confirmar; luego desactiva esa protección o agrega tu dominio a los sitios permitidos en la app del proveedor. Si necesitas ayuda para hacerlo, contacta al soporte de tu proveedor de internet. |
| Docker muestra **“Virtualization support not detected”**                        | En Windows, abre **Administrador de tareas → Rendimiento → CPU** y verifica que **Virtualización** figure como habilitada. Si está deshabilitada, necesitarás activarla desde el BIOS/UEFI siguiendo las instrucciones del fabricante de tu computadora. Si ya está habilitada y Docker continúa mostrando el error, lo mejor es consultar la documentación oficial de Docker para revisar la configuración específica de tu equipo.                                                                                    |
| Mi problema no aparece en esta tabla o la solución indicada no funciona         | Como cada computadora puede tener una configuración diferente, no siempre es posible cubrir todos los casos en este tutorial. Si te encuentras con un inconveniente específico de tu entorno, te recomendamos consultar la documentación de Docker, n8n, tu sistema operativo u otros recursos técnicos para resolverlo. **Para poder mantener este recurso disponible para todos, Alaimo Labs no puede brindar troubleshooting individual sobre instalaciones locales o configuraciones particulares de cada equipo.** |

---

## English

### How to download

1. Download everything from this link: **<https://github.com/alaimo-labs/n8n-install/archive/refs/heads/main.zip>**
2. Unzip the file (double-click the downloaded ZIP).
3. Keep the folder somewhere permanent (e.g. Documents) — that's where the scripts and your configuration will live.

No GitHub account or git knowledge needed: the link downloads everything directly.

### Requirements (one time only)

**1. Docker Desktop**

1. Download Docker Desktop from <https://www.docker.com/products/docker-desktop/> and run the installer (next → next → finish).
2. **Windows**: if the installer asks to enable WSL 2, accept. When the installation finishes, **reboot the computer** (even if it doesn't ask — Windows needs it to recognize Docker).
3. Open Docker Desktop and wait until it says **Engine running** (bottom left). No Docker account needed — if it asks you to sign in, skip it.

**2. Free ngrok account** (so webhooks work from the internet)

1. Create an account at <https://dashboard.ngrok.com/signup>.
2. Copy your **authtoken**: <https://dashboard.ngrok.com/get-started/your-authtoken>.
3. Copy your **free domain**: <https://dashboard.ngrok.com/domains>. ngrok already assigned your account a "dev domain" (something like `odd-name-seventy.ngrok-free.dev`) — no need to create anything, just copy it with the copy icon. It's one per account and never changes.

Keep the authtoken and domain handy: the script asks for them on first run and saves them to `n8n-config.txt` (next to the script).

### Start n8n

- **Windows**: double-click `windows/start-n8n.bat`.
- **Mac**: double-click `mac/start-n8n.command`.
  - The first time, macOS may block it as a downloaded file. Right-click the file → **Open** → **Open** (only needed once).

The first run asks for your ngrok authtoken and domain, then downloads n8n (a few minutes). When it finishes, your browser opens at `https://your-domain.ngrok-free.dev`, where you create your local user and start building workflows.

> **Important**: always use the editor at your ngrok domain (not `localhost:5678`). On `localhost`, forms (Form Trigger) won't open when you execute the workflow, because the browser blocks communication between the two domains (CORS). The first time you open your domain, ngrok shows a warning page: click **Visit Site** (once per browser).

### Webhooks (e.g. from Lovable)

Webhook URLs you copy from the n8n editor already use your public domain (`https://your-domain.ngrok-free.dev/webhook/...`): paste them straight into Lovable or any other service. The domain stays the same across restarts.

Three important notes:

- Webhooks only respond **while your computer is on and n8n is running**.
- **If Lovable calls the webhook from the browser** (frontend code), ngrok's free plan intercepts the first browser visit with a warning page. Fix: in your Lovable code, add the header `ngrok-skip-browser-warning: true` to the `fetch` call. Backend calls (edge functions, APIs, server-side forms) don't have this issue.
- This setup is for **learning and prototyping**. For production, run n8n on a server (VPS or n8n Cloud).

### Stop and update

- Stop: double-click `stop-n8n`. Your workflows are saved.
- Update n8n: double-click `update-n8n`. Your workflows are **not** lost (they live in a Docker volume named `n8n_data`).

### Troubleshooting

| Symptom                                                              | Fix                                                                                                                                                                                                  |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "Docker Desktop is not running"                                      | Open Docker Desktop, wait for **Engine running**, try again.                                                                                                                                         |
| Docker Desktop says "Engine running" but the script says it isn't    | Reboot the computer (Windows needs it after installing Docker Desktop) and try again.                                                                                                                |
| Not sure where to double-click                                       | The double-click happens on your computer, not on the GitHub page: download the ZIP (link above), unzip it, open the folder and go into `windows` or `mac` depending on your system.                 |
| "The tunnel did not start (wrong authtoken or domain)"               | Delete the `n8n-config.txt` file next to the script and run `start-n8n` again with the correct values.                                                                                               |
| Browser shows an error on open                                       | Wait 30 seconds and reload; the first run takes longer.                                                                                                                                              |
| n8n won't load after rebooting                                       | Double-click `start-n8n` again.                                                                                                                                                                      |
| A webhook doesn't respond from outside                               | Check the computer is on, n8n is running, and the URL starts with `https://your-domain.ngrok-free.dev`. If calling from frontend code, add the `ngrok-skip-browser-warning` header.                  |
| Executing a workflow with a form doesn't open the form               | Use the editor at `https://your-domain.ngrok-free.dev` (not `localhost`). If the tab was open from before a restart, reload it with Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows).                     |
| The form says "isn't listening yet" or "Problem submitting response" | Test mode expires after ~2 minutes: click "Execute workflow" again and submit the form right away. For a permanent URL, publish the workflow (**Publish**) and use the production URL (`/form/...`). |
| `X-Forwarded-For` / `trust proxy` error in the logs                  | Your script is from an old version: download the current `start-n8n` and run it again.                                                                                                               |
| `ERR_SSL_PROTOCOL_ERROR` or a "site blocked" page when opening your domain | Your router's or internet provider's security feature is blocking the ngrok domain (happens with Spectrum "Advanced Security" and similar). Try mobile data to confirm; then disable that protection or add your domain to the allowed sites in the provider's app. If you need help doing this, contact your internet provider's support. |
| Docker shows **“Virtualization support not detected”**             | On Windows, open **Task Manager → Performance → CPU** and check whether **Virtualization** is enabled. If it is disabled, you’ll need to enable it in your computer’s BIOS/UEFI by following the instructions from your device manufacturer. If it is already enabled and Docker still shows the error, the best next step is to consult Docker’s official documentation for troubleshooting your specific setup.                                                                    |
| My issue isn’t listed here, or the suggested solution doesn’t work | Every computer can have a different configuration, so it isn’t possible for this tutorial to cover every scenario. If you run into an issue specific to your environment, we recommend consulting the Docker, n8n, or operating system documentation, as well as other technical resources that may help. **To keep this resource available to everyone, Alaimo Labs is not able to provide individual troubleshooting for local installations or machine-specific configurations.** |

