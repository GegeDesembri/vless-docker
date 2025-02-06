FROM --platform=${TARGETPLATFORM} alpine:latest AS builder
LABEL maintainer="Gege Desembri"

WORKDIR /root
ARG TAG="v25.1.30"
COPY xray.sh /root/xray.sh

RUN apk add --no-cache bash wget run-parts tzdata openssl ca-certificates && \
	ln -sf $(which run-parts) /usr/bin/run-parts && \
	update-ca-certificates --fresh && \
	mkdir -p /etc/xray /usr/local/share/xray /var/log/xray && \
	chmod +x /root/xray.sh && \
	/root/xray.sh "${TARGETPLATFORM}" "${TAG}"

FROM alpine:latest

RUN apk add --no-cache tzdata openssl ca-certificates && \
	mkdir -p /etc/xray /etc/server-ssl /usr/local/share/xray /var/log/xray

COPY --from=builder /usr/local/bin/xray /usr/local/bin/xray
COPY --from=builder /usr/local/share/xray/geosite.dat /usr/local/share/xray/geosite.dat
COPY --from=builder /usr/local/share/xray/geoip.dat /usr/local/share/xray/geoip.dat
COPY config /usr/local/share/xray/config

WORKDIR /etc/xray

ENV XRAY_LOCATION_ASSET="/usr/local/share/xray/"
ENTRYPOINT ["/usr/local/bin/xray", "run", "-confdir", "/usr/local/share/xray/config"]