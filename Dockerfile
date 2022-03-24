FROM python:alpine

ARG version=0.11.2

RUN apk add --no-cache \
      py3-pillow \
      py3-aiohttp \
      py3-magic \
      py3-ruamel.yaml \
      py3-commonmark \
      py3-prometheus-client \
      # Indirect dependencies
      py3-idna \
      #moviepy
        py3-decorator \
        py3-tqdm \
        py3-requests \
        #imageio
          py3-numpy \
      #py3-telethon \ (outdated)
        # Optional for socks proxies
        py3-pysocks \
        py3-pyaes \
        # cryptg
          py3-cffi \
	  py3-qrcode \
      py3-brotli \
      # Other dependencies
      ffmpeg \
      ca-certificates \
      su-exec \
      netcat-openbsd \
      # encryption
      py3-olm \
      py3-pycryptodome \
      py3-unpaddedbase64 \
      py3-future \
      bash \
      curl \
      jq \
      yq

RUN apk add --virtual .build-deps python3-dev libffi-dev build-base \
 && pip3 install mautrix-telegram[all]==$version \
 && apk del .build-deps

WORKDIR /opt/mautrix-telegram
COPY docker-run.sh /opt/mautrix-telegram
COPY example-config.yaml /opt/mautrix-telegram

VOLUME /data
ENV UID=1337 GID=1337 FFMPEG_BINARY=/usr/bin/ffmpeg
EXPOSE 29317

CMD ["/opt/mautrix-telegram/docker-run.sh"]
