FROM ubuntu
ARG GOMPLATE_VERSION=v3.11.2
RUN apt update && \
    apt install -y stunnel curl && \
    curl -o /usr/local/bin/gomplate -sSL https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_linux-amd64 && \
    chmod 755 /usr/local/bin/gomplate
COPY start.sh /stunnel/start.sh
COPY stunnel.conf.gomplate /stunnel/stunnel.conf.gomplate
CMD ["/bin/bash", "/stunnel/start.sh"]
