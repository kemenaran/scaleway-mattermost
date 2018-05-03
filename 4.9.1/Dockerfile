## -*- docker-image-name: "scaleway/mattermost:latest" -*-

ARG SCW_ARCH

FROM scaleway/ubuntu:${SCW_ARCH}-xenial

MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get -q update \
 && apt-get install -y -q \
      nginx-full \
      supervisor \
      postfix \
      postgresql \
      postgresql-contrib \
 && apt-get clean

# Install mattermost
RUN cd /root/ \
 && wget https://releases.mattermost.com/4.9.1/mattermost-team-4.9.1-linux-amd64.tar.gz -O mattermost.tar.gz \
 && tar -xvzf mattermost.tar.gz \
 && rm -fr mattermost.tar.gz \
 && mkdir -p /mattermost/data

# Patch rootfs
COPY ./overlay /

# Add mattermost installation script
RUN update-rc.d mattermost defaults


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
