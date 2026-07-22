# n8n local, gratis y con webhooks / n8n locally, free, with webhooks

Scripts para que cualquier persona (sin conocimientos técnicos) corra n8n gratis en su computadora, con webhooks accesibles desde internet (Lovable, formularios, APIs, etc.).

Scripts so anyone (no technical skills needed) can run n8n for free on their computer, with webhooks reachable from the internet (Lovable, forms, APIs, etc.).

> Nota / Note: n8n discontinuó su servicio de túnel propio (`--tunnel`) en 2026, por eso estos scripts usan **ngrok** (gratis) para exponer los webhooks. / n8n discontinued its own tunnel service (`--tunnel`) in 2026, which is why these scripts use **ngrok** (free) to expose webhooks.

---

## Español

### Requisitos (una sola vez)

**1. Docker Desktop**

1. Descarga Docker Desktop desde <https://www.docker.com/products/docker-desktop/> y ejecuta el instalador (siguiente → siguiente → finalizar).
2. **Windows**: si el instalador te pide habilitar WSL 2, acepta y reinicia la computadora una vez.
3. Abre Docker Desktop y espera a que diga **Running**. No necesitas crear cuenta: si te pide iniciar sesión, puedes saltarlo.

**2. Cuenta gratis de ngrok** (para que los webhooks funcionen desde internet)

1. Crea una cuenta en <https://dashboard.ngrok.com/signup>.
2. Copia tu **authtoken**: <https://dashboard.ngrok.com/get-started/your-authtoken>.
3. Copia tu **dominio gratis**: <https://dashboard.ngrok.com/domains>. ngrok ya le asignó a tu cuenta un "dev domain" (algo como `nombre-raro-setenta.ngrok-free.dev`) — no necesitas crear nada, solo copiarlo con el ícono de copiar. Es uno por cuenta y no cambia nunca.

Ten a mano el authtoken y el dominio: el script te los pedirá la primera vez y los guardará en `n8n-config.txt` (junto al script).

### Iniciar n8n

- **Windows**: doble clic en `windows/start-n8n.bat`.
- **Mac**: doble clic en `mac/start-n8n.command`.
  - La primera vez, macOS puede bloquearlo por ser un archivo descargado. Haz clic derecho sobre el archivo → **Abrir** → **Abrir** (solo hace falta una vez).

La primera vez pide el authtoken y el dominio de ngrok, y descarga n8n (unos minutos). Al terminar, se abre el navegador en `http://localhost:5678`, donde creas tu usuario local y ya puedes armar workflows.

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

| Síntoma | Solución |
|---|---|
| "Docker Desktop no está corriendo" | Abre Docker Desktop, espera al estado **Running** y vuelve a intentar. |
| "El túnel no arrancó (authtoken o dominio incorrectos)" | Borra el archivo `n8n-config.txt` que está junto al script y vuelve a ejecutar `start-n8n` con los datos correctos. |
| El navegador muestra error al abrir | Espera 30 segundos y recarga la página; la primera vez tarda más. |
| n8n no carga después de reiniciar la compu | Doble clic en `start-n8n` otra vez. |
| Un webhook no responde desde afuera | Verifica que la compu esté encendida, n8n corriendo, y que la URL empiece con `https://tu-dominio.ngrok-free.dev`. Si lo llamas desde código frontend, agrega el header `ngrok-skip-browser-warning`. |

---

## English

### Requirements (one time only)

**1. Docker Desktop**

1. Download Docker Desktop from <https://www.docker.com/products/docker-desktop/> and run the installer (next → next → finish).
2. **Windows**: if the installer asks to enable WSL 2, accept and reboot once.
3. Open Docker Desktop and wait until it says **Running**. No Docker account needed — if it asks you to sign in, skip it.

**2. Free ngrok account** (so webhooks work from the internet)

1. Create an account at <https://dashboard.ngrok.com/signup>.
2. Copy your **authtoken**: <https://dashboard.ngrok.com/get-started/your-authtoken>.
3. Copy your **free domain**: <https://dashboard.ngrok.com/domains>. ngrok already assigned your account a "dev domain" (something like `odd-name-seventy.ngrok-free.dev`) — no need to create anything, just copy it with the copy icon. It's one per account and never changes.

Keep the authtoken and domain handy: the script asks for them on first run and saves them to `n8n-config.txt` (next to the script).

### Start n8n

- **Windows**: double-click `windows/start-n8n.bat`.
- **Mac**: double-click `mac/start-n8n.command`.
  - The first time, macOS may block it as a downloaded file. Right-click the file → **Open** → **Open** (only needed once).

The first run asks for your ngrok authtoken and domain, then downloads n8n (a few minutes). When it finishes, your browser opens at `http://localhost:5678`, where you create your local user and start building workflows.

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

| Symptom | Fix |
|---|---|
| "Docker Desktop is not running" | Open Docker Desktop, wait for **Running**, try again. |
| "The tunnel did not start (wrong authtoken or domain)" | Delete the `n8n-config.txt` file next to the script and run `start-n8n` again with the correct values. |
| Browser shows an error on open | Wait 30 seconds and reload; the first run takes longer. |
| n8n won't load after rebooting | Double-click `start-n8n` again. |
| A webhook doesn't respond from outside | Check the computer is on, n8n is running, and the URL starts with `https://your-domain.ngrok-free.dev`. If calling from frontend code, add the `ngrok-skip-browser-warning` header. |
