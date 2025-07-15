# Use a lightweight Debian-based image as a base
FROM fluent/fluentd-kubernetes-daemonset:v1.18-debian-opensearch-amd64-1@sha256:b9379136857868b549f82ea76e091f77ffa4db750df739f4d15c8ba0492f4d01

# Metadata for the extension
LABEL org.opencontainers.image.title="Fluentd"
LABEL org.opencontainers.image.description="Custom Fluentd image"
LABEL org.opencontainers.image.source="https://github.com/jaipongchang/fluentd"

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Use root user
USER root

# Install the required packages
RUN apt-get update 
RUN apt-get install -y --no-install-recommends build-essential
RUN apt-get install -y --no-install-recommends libgeoip-dev
RUN apt-get install -y --no-install-recommends libmaxminddb-dev
RUN apt-get install -y --no-install-recommends automake
RUN apt-get install -y --no-install-recommends autoconf
RUN apt-get install -y --no-install-recommends libtool
RUN apt-get install -y --no-install-recommends zlib1g-dev

# Install plugins
RUN fluent-gem install fluent-plugin-grafana-loki --no-document
RUN fluent-gem install fluent-plugin-geoip --no-document

# Purge installed packages
RUN apt purge -y --auto-remove build-essential
RUN apt purge -y --auto-remove automake
RUN apt purge -y --auto-remove autoconf
RUN apt purge -y --auto-remove libtool
RUN apt clean

# Remove apt and unused files
RUN rm -rf /usr/bin/apt* /usr/lib/apt /etc/apt /var/lib/apt /var/cache/apt /var/lib/dpkg
RUN rm -rf /tmp/* /var/tmp/*
RUN rm -rf /usr/bin/perl /usr/bin/python* /usr/bin/pip*

# Switch to non-root user
USER 1000

# Default to Fluentd entrypoint or bash for debug
CMD ["/fluentd/entrypoint.sh"]