FROM simplefs/switch-base:1.10.12

COPY bin /tmp/bin
COPY conf /tmp/conf
COPY templates /tmp/templates
COPY entrypoint.d /tmp/bin/entrypoint.d

RUN mv /tmp/templates/fs_cli.conf /etc/fs_cli.conf
RUN mv -f /tmp/templates /etc/switch/templates

RUN mv /etc/switch/conf /etc/switch/conf.bak
RUN mv /tmp/conf /etc/switch/conf

RUN chmod +x /tmp/bin/*
RUN mv /tmp/bin/entrypoint.sh   /docker-entrypoint.sh
RUN mv /tmp/bin/healthcheck.sh  /healthcheck.sh
RUN mv /tmp/bin/entrypoint.d    /entrypoint.d

ENV EXTERNAL_IP "103.229.40.170"
ENV CORE_DSN "pgsql://host=192.168.13.137 port=15432 dbname=switch user=postgres password=Default#Postgres@6699"
ENV CORE_SCHEMA "true"
ENV SIP_PORT "5080"
ENV CODECS "PCMU,PCMA"
ENV SWITCHNAME "switch"
ENV LOG_LEVEL "info"
ENV CONSOLE_LOG_LEVEL "info"
ENV MAX_RTP_PORT "22000"
ENV MIN_RTP_PORT "20000"

HEALTHCHECK --interval=30s --timeout=5s CMD /healthcheck.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]

# CMD ["tail", "-f", "/dev/null"]