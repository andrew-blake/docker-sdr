# vim:set ft=dockerfile:
FROM phusion/baseimage:0.9.18
MAINTAINER Andrew Blake "github@blakenet.uk"

RUN true \
    && apt-get update \
    && apt-get install -y --no-install-recommends -q -o APT::Install-Recommends=false -o APT::Install-Suggests=false\
        build-essential \
        cmake \
        ca-certificates \
        g++ \
        gcc \
        make \
        perl \
        wget \
        curl \
        python-pip \
        lsof \
        net-tools \
        git \
        usbutils \
        libusb-1.0.0-dev \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data/logs/

ADD ./setup/build-rtl-sdr.sh .
RUN /build-rtl-sdr.sh

ADD ./setup/build-rtl-433.sh .
RUN /build-rtl-433.sh

#
# Add services to runit
#

RUN mkdir /etc/service/log_temperatures
COPY run_log_temperatures /etc/service/log_temperatures/run
RUN chown root /etc/service/log_temperatures/run
RUN chmod 755 /etc/service/log_temperatures/run

##
## DEBUG ONLY - enabled SSH
##
#RUN rm -f /etc/service/sshd/down
#
## Regenerate SSH host keys. baseimage-docker does not contain any, so you
## have to do that yourself. You may also comment out this instruction; the
## init system will auto-generate one during boot.
#RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
#
#COPY id_rsa.pub /root/.ssh/authorized_keys
#RUN chmod 600 /root/.ssh/authorized_keys

# infinite loop to ensure "make start" to not exit, and we can "make exec-bash"
#CMD /bin/bash -c "while sleep 2; do echo 'thinking'; done"

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

WORKDIR /data/logs
