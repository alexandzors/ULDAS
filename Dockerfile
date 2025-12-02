FROM python:3.12-slim

LABEL maintainer="alexandzors"
LABEL description="ULDAS - Unified Language Detection and Subtitle Processing"
LABEL org.opencontainers.image.source="https://github.com/alexandzors/ULDAS"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    mkvtoolnix \
    tesseract-ocr \
    tesseract-ocr-eng \
    gosu \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY ULDAS.py .
RUN mkdir -p /app/config
COPY config/config.example.yml /app/config/
RUN mkdir -p /media
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV PYTHONUNBUFFERED=1
ENV PUID=0
ENV PGID=0

ENTRYPOINT ["/entrypoint.sh"]