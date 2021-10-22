#
# Dockerfile for Debian + AdoptOpenJDK
#
FROM sismics/debian:11.0.0
MAINTAINER Jean-Marc Tremeaux <jm.tremeaux@sismics.com>

# Run Debian in non interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Download and install JDK
ENV JAVA_HOME /usr/lib/jvm/adoptopenjdk-11-hotspot-amd64/
ENV JAVA_OPTS "-Duser.timezone=Europe/Paris -Dfile.encoding=UTF-8 -Xmx1024m"
ENV PATH "$JAVA_HOME/bin:$PATH"
RUN apt-get update && \
    apt-get -y install adoptopenjdk-11-hotspot && \
    rm -rf /var/lib/apt/lists/*
