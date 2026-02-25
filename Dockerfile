FROM python:3.13-slim-bookworm
ARG MS_REGISTRY_VERSION=main
ENV PYTHONUNBUFFERED=1

RUN mkdir -p /mnt/logs/

# System deps
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    libssl-dev \
    postgresql-client \
    git && \
    rm -rf /var/lib/apt/lists/*

# Python deps (controlled from this repo)
ADD requirements.txt requirements.txt
RUN pip install -r requirements.txt pyuwsgi

# Trim build deps
RUN apt-get --purge autoremove -y \
    build-essential \
    python3-dev \
    libssl-dev

# Clone app code from GitHub
RUN git clone --branch ${MS_REGISTRY_VERSION} --depth 1 \
    https://github.com/AniaAlex/ms-registry.git /tmp/ms-registry

# uWSGI config (controlled from this repo)
ADD uwsgi.ini /etc/uwsgi/app.ini

# Copy app code
RUN mkdir -p /var/www/static /var/www/media /app && \
    cp -r /tmp/ms-registry/ms_registry/. /app/ && \
    rm -rf /tmp/ms-registry

WORKDIR /app

ADD start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3030 8000 8443
CMD ["/start.sh"]
