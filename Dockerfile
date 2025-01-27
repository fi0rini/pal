FROM debian:stable-slim

COPY ./pal /pal/
COPY ./entrypoint.sh ./localhost.key ./localhost.pem /etc/pal/

WORKDIR /pal

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends \
        curl \
        tzdata \
        ca-certificates \
        jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /etc/pal/pal.db /etc/pal/actions /pal/upload && \
    addgroup --gid 101010 --system pal && \
    adduser --uid 101010 --system --ingroup pal --home /pal --shell /sbin/nologin pal && \
    chown -Rf pal:pal /pal /etc/pal

USER pal

EXPOSE 8443

ENTRYPOINT ["/etc/pal/entrypoint.sh"]
