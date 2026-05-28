# AlmaLinux Web Terminal

Deploy AlmaLinux as a browser-accessible terminal using Docker and `ttyd`. This repository is ready for Railway and lets you choose the AlmaLinux image tag from an environment variable at build time.

## Features

- AlmaLinux terminal in the browser.
- Basic authentication through `USERNAME` and `PASSWORD`.
- Dynamic AlmaLinux tag through `ALMALINUX_VERSION`.
- Railway-ready Dockerfile and config-as-code.
- Persistent workspace path at `/root/workspace`.
- Optional Docker Compose setup for local testing.

## Railway Deploy

1. Push this repository to GitHub.
2. Create a new Railway service from the repo.
3. Add these service variables:

```env
ALMALINUX_VERSION=10
USERNAME=admin
PASSWORD=use-a-strong-password
WORKSPACE_DIR=/root/workspace
TTYD_WRITABLE=true
TZ=Asia/Jakarta
```

4. Deploy the service.
5. Generate a Railway public domain from the service networking settings.
6. Open the domain and log in with `USERNAME` and `PASSWORD`.

Railway supplies `PORT` automatically. The container listens on `0.0.0.0:$PORT`.

## Version Selection

Set `ALMALINUX_VERSION` to the AlmaLinux image tag you want to build:

```env
ALMALINUX_VERSION=10
```

Common values are `10`, `9`, `8`, or any valid tag published by the official AlmaLinux image. Because Docker base images are selected during build, changing `ALMALINUX_VERSION` requires a new deploy/rebuild.

## Required Variables

| Variable | Default | Description |
| --- | --- | --- |
| `ALMALINUX_VERSION` | `10` | AlmaLinux Docker image tag used in `FROM almalinux:${ALMALINUX_VERSION}`. |
| `USERNAME` | `admin` | Browser terminal username. |
| `PASSWORD` | none | Browser terminal password. The app exits if this is missing. |
| `PORT` | `7681` | Web terminal port. Railway injects this automatically. |
| `WORKSPACE_DIR` | `/root/workspace` | Directory opened when the shell starts. Mount a Railway volume here for persistence. |
| `TTYD_WRITABLE` | `true` | Enables browser keyboard input. Set to `false` for readonly mode. |
| `TZ` | none | Optional timezone, for example `Asia/Jakarta`. |
| `TTYD_VERSION` | `1.7.7` | `ttyd` release downloaded during build. |

## Local Test

Build and run the default AlmaLinux 10 image:

```bash
docker build -t almalinux-web-terminal .
docker run --rm -it \
  -p 7681:7681 \
  -e USERNAME=admin \
  -e PASSWORD=secret \
  almalinux-web-terminal
```

Open `http://localhost:7681`.

Or use Docker Compose:

```bash
cp .env.example .env
docker compose up --build
```

For local Compose, `TERMINAL_USERNAME` and `TERMINAL_PASSWORD` are used so your host shell's `USERNAME` variable does not override the login.

Build another AlmaLinux tag:

```bash
docker build \
  --build-arg ALMALINUX_VERSION=9 \
  -t almalinux-web-terminal:9 .
```

## Persistence

For Railway, mount a volume to:

```text
/root/workspace
```

Files saved there will survive redeploys when a volume is attached.

## Troubleshooting

If the page opens but you cannot type, check the deploy logs. This line means the terminal is readonly:

```text
The --writable option is not set, will start in readonly mode
```

Set `TTYD_WRITABLE=true` and redeploy. The startup log should show:

```text
Input mode: writable
```

## Security Notes

- Always set a strong `PASSWORD`.
- Do not expose this terminal publicly without authentication.
- Rotate the password if the URL has been shared.
