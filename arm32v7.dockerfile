### Build ARMv7 Container
### Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
FROM alpine:3 AS builder
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz

# hadolint ignore=DL3018,DL3019,DL4006
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

### Build Final Container
FROM arm32v7/alpine:3

# Add QEMU
COPY --from=builder qemu-arm-static /usr/bin

# Install The Chrony Package
# hadolint ignore=DL3018
RUN apk --update --no-cache add chrony tini && \
  rm -rf /var/cache/apk/* /etc/chrony

# Copy The Start Script
COPY files/start.sh /usr/local/bin/start.sh
RUN chmod 0755 /usr/local/bin/start.sh

# Set The Work Directory And Command Points
WORKDIR /tmp
EXPOSE 123/udp
ENTRYPOINT ["tini", "--"]
CMD ["/usr/local/bin/start.sh"]
