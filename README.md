# Docker MS Registry

Builds a Docker image for the MS Registry Django application. App code is cloned from [AniaAlex/ms-registry](https://github.com/AniaAlex/ms-registry) at build time.

## Quick Start

```bash
# Build the image
make build

# Remove the image
make clean
```

## Build Arguments

| Argument              | Default | Description                          |
|-----------------------|---------|--------------------------------------|
| `MS_REGISTRY_VERSION` | `main`  | Branch or tag to clone from GitHub   |

```bash
docker build -f Dockerfile --build-arg MS_REGISTRY_VERSION=v1.2.3 -t docker-ms-registry:latest .
```

## Exposed Ports

| Port | Description       |
|------|-------------------|
| 3030 | uWSGI socket      |
| 8000 | HTTP              |
| 8443 | HTTPS             |

## Repository Contents

- `Dockerfile` — image definition; clones app code from GitHub at build time
- `requirements.txt` — Python dependencies installed into the image
- `uwsgi.ini` — uWSGI configuration copied into the image at `/etc/uwsgi/app.ini`
- `start.sh` — container entrypoint script
- `Makefile` — convenience targets (`build`, `clean`)
