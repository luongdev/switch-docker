FROM simplefs/switch-base:1.10.12

COPY bin /tmp/bin
COPY conf /tmp/conf
COPY template /tmp/template

RUN mv /tmp/template/fs_cli.conf /etc/fs_cli.conf

RUN mv /etc/switch/conf /etc/switch/conf.bak
RUN mv /tmp/conf /etc/switch/conf

RUN chmod +x /tmp/bin/*
RUN mv /tmp/bin/entrypoint.sh   /docker-entrypoint.sh
RUN mv /tmp/bin/healthcheck.sh  /healthcheck.sh

HEALTHCHECK --interval=30s --timeout=5s CMD /healthcheck.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]

# CMD ["tail", "-f", "/dev/null"]