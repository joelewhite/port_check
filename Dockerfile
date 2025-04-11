FROM bash:latest

LABEL maintainer="Joel E. White"
LABEL description="Containerized Bash-only TCP/UDP port checker"

WORKDIR /opt/port_check

COPY port_check.sh /usr/bin/port_check
RUN chmod +x /usr/bin/port_check

ENV HOSTS="127.0.0.1"
ENV PORTS="22,80,443"
ENV PROTOCOL="tcp"
ENV LOGFILE="/var/log/port_check.log"
ENV QUIET="false"

RUN mkdir -p /var/log

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["ARGS=\"--hosts \"$HOSTS\" --ports \"$PORTS\"\"; \
      [ \"$PROTOCOL\" = \"udp\" ] && ARGS=\"$ARGS --udp\"; \
      [ \"$QUIET\" = \"true\" ] && ARGS=\"$ARGS --quiet\"; \
      [ -n \"$LOGFILE\" ] && ARGS=\"$ARGS --log $LOGFILE\"; \
      exec /usr/bin/port_check $ARGS"]
