## -*- docker-image-name: "scaleway/owncloud:latest" -*-
FROM scaleway/ubuntu:amd64-xenial
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/ubuntu:armhf-xenial       # arch=armv7l
#FROM scaleway/ubuntu:arm64-xenial       # arch=arm64
#FROM scaleway/ubuntu:i386-xenial        # arch=i386
#FROM scaleway/ubuntu:mips-xenial        # arch=mips


MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get -q update \
 && echo "O" | apt-get -y -q upgrade \
 && apt-get install -y -q \
      nginx-full \
      supervisor \
      postfix \
      postgresql \
      postgresql-contrib \
 && apt-get clean

# Install mattermost
RUN cd /root/ \
 && wget https://releases.mattermost.com/3.1.0/mattermost-team-3.1.0-linux-amd64.tar.gz -O mattermost.tar.gz \
 && tar -xvzf mattermost.tar.gz \
 && rm -fr mattermost.tar.gz \
 && mkdir -p /mattermost/data

# Patch rootfs
COPY ./overlay /

# Add mattermost installation script
RUN update-rc.d mattermost defaults


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
