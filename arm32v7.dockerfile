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
RUN apk --update --no-cache add chrony && \
  rm -rf /var/cache/apk/* /etc/chrony && \
  touch /var/lib/chrony/chrony.drift && \
  chown chrony:chrony -R /var/lib/chrony

# Set The Work Directory And Command Points
WORKDIR /tmp
EXPOSE 123/udp
ENTRYPOINT ["chronyd"]
CMD ["-d", "-s","-f","/etc/chrony.conf"]

# Check Process Within The Container Is Healthy
HEALTHCHECK --interval=60s --timeout=5s CMD chronyc tracking > /dev/null

# Copy The Configuration Into The Container
COPY files/chrony.conf /etc/chrony.conf
