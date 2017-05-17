#
# Dockerfile for Debian + Oracle JDK
#
# For the download URL see http://stackoverflow.com/questions/10268583/how-to-automate-download-and-installation-of-java-jdk-on-linux

FROM debian:jessie
MAINTAINER Jean-Marc Tremeaux <jm.tremeaux@sismics.com>

# Run Debian in non interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Configure locale and timezone
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN echo "Europe/Paris" > /etc/timezone
RUN dpkg-reconfigure tzdata
RUN echo "alias ll='ls -l'" > ~/.bashrc

# Download and install JDK and a few utils
RUN sed -i 's/main/main contrib/' /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y -q install java-package vim less procps unzip wget curl fakeroot libgl1-mesa-glx libgtk2.0-0 libxslt1.1 libxtst6 libxxf86vm1 && \
    useradd --home /home/fakeroot -m fakeroot && \
    cd ~fakeroot && \
    wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz && \
    su fakeroot -c "fakeroot yes|make-jpkg jdk-8u131-linux-x64.tar.gz" && \
    rm jdk-*.tar.gz && \
    dpkg -i oracle-java*.deb && \
    apt-get -y -q --purge remove java-package fakeroot autopoint binutils bsdmainutils build-essential cpp debhelper dpkg-dev file g++ gcc make perl && \
    apt-get -y -q autoremove && \
    dpkg --list |grep "^rc" | cut -d " " -f 3 | xargs dpkg --purge && \
    apt-get clean

ENV JAVA_HOME /usr/lib/jvm/jdk-8-oracle-x64/
ENV JAVA_OPTS -Duser.timezone=Europe/Paris -Dfile.encoding=UTF-8 -Xmx1024m
