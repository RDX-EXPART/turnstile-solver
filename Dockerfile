FROM python:3.13-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONWARNINGS=ignore \
    MAX_WORKERS=2 \
    PORT=9988 \
    HEADLESS=false \
    XDG_CACHE_HOME=/opt/camoufox-cache \
    DB_PATH=/tmp/solver.db

RUN apt-get update && apt-get install -y --no-install-recommends \
        xvfb \
        dumb-init \
        ca-certificates \
        fonts-liberation \
        fonts-noto-core \
        fonts-noto-cjk \
        fonts-dejavu-core \
        libgtk-3-0 \
        libdbus-glib-1-2 \
        libxt6 \
        libasound2 \
        libx11-xcb1 \
        libxcomposite1 \
        libxdamage1 \
        libxfixes3 \
        libxrandr2 \
        libpango-1.0-0 \
        libnss3 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libcups2 \
        libxkbcommon0 \
        libgbm1 \
        libglib2.0-0 \
        libexpat1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Ensure cache directory exists and is world-writable for non-root runtime users
RUN mkdir -p /opt/camoufox-cache /tmp/ts_profile /tmp/solver \
    && chmod -R 777 /opt/camoufox-cache /tmp/ts_profile /tmp/solver

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && python -m camoufox fetch \
    && chmod -R 777 /opt/camoufox-cache

COPY app ./app
COPY web ./web
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh && chmod -R 777 /app

EXPOSE 9988

ENTRYPOINT ["/usr/bin/dumb-init", "--", "./entrypoint.sh"]
