ARG PYTHONVERSION=3.9
ARG version=0.11.2

FROM python:$PYTHONVERSION as builder

# Reduce build time for armhf
COPY pip.conf /etc/pip.conf
# python-olm will be compiled regardless of line above
RUN apt-get update && apt-get install -y libolm-dev
RUN pip install --prefix="/install" --no-warn-script-location mautrix-telegram[all]==$version

FROM python:$PYTHONVERSION-slim as runner

RUN apt-get update && apt-get install -y \
    # 321 megabytes from only this one !!! *alpine linux intensifies*
    ffmpeg \
    libolm3 \
    libmagic1 \
    # idk if this is needed
    # ca-certificates \
    # netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /usr/local

WORKDIR /opt/mautrix-telegram
COPY docker-run.sh /opt/mautrix-telegram
COPY example-config.yaml /opt/mautrix-telegram

VOLUME /data
ENV UID=1337 GID=1337 FFMPEG_BINARY=/usr/bin/ffmpeg
EXPOSE 29317

CMD ["/opt/mautrix-telegram/docker-run.sh"]
