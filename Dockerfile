# Chrony NTP Docker Image
FROM geoffh1977/alpine:latest
LABEL maintainer="geoffh1977 <geoffh1977@gmail.com>"

# hadolint ignore=DL3002
USER root

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
COPY config/chrony.conf /etc/chrony.conf
