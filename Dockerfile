## -*- docker-image-name: "scaleway/owncloud:latest" -*-
FROM scaleway/ubuntu:amd64-wily
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/ubuntu:armhf-wily       # arch=armv7l
#FROM scaleway/ubuntu:arm64-wily       # arch=arm64
#FROM scaleway/ubuntu:i386-wily        # arch=i386
#FROM scaleway/ubuntu:mips-wily        # arch=mips


MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get -q update \
 && apt-get -y -q upgrade \
 && apt-get install -y -q \
      nginx-full \
      supervisor \
      postfix \
 && apt-get clean

# Install mattermost
RUN cd /root/ \
 && wget https://github.com/mattermost/platform/releases/download/v2.1.0/mattermost.tar.gz \
 && tar -xvzf mattermost.tar.gz \
 && rm -fr mattermost.tar.gz \
 && mkdir -p /mattermost/data

# Patch rootfs
COPY ./overlay /

# Add mattermost installation script
RUN update-rc.d mattermost defaults


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
