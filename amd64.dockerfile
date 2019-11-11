## Build Standard AMD64 Container
FROM alpine:3

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
