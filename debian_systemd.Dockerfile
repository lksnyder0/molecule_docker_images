# Inspired by https://github.com/alehaa/docker-debian-systemd/blob/master/Dockerfile
ARG TAG=latest
FROM lksnyder0/debian:${TAG}

# The 'container' environment variable tells systemd that it's running inside a
# Docker container environment.
ENV container docker

# Configure the debconf frontend.
#
# This image doesn't include whiptail, dialog, nor the readline perl module.
# Therefore, the debconf frontend will be set to 'teletype' to avoid error
# messages about no dialog frontend could be found.
RUN echo 'debconf debconf/frontend select teletype' | debconf-set-selections


# Install the necessary packages.
#
# In addition to the regular Debian base image, a BASIC set of packages from the
# Debian minimal configuration will be installed. After all packages have been
# installed, the apt caches and some log files will be removed to minimize the
# image.
#
# NOTE: An upgrade will be performed to include updates and security fixes of
#       installed packages that received updates in the Debian repository after
#       the upstream image has been created.
#
# NOTE: No syslog daemon will be installed, as systemd's journald should fit
#       most needs. Please file an issue if you think this should be changed.
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends \
        systemd      \
        systemd-sysv \
        cron         \
        anacron && \
    apt-get clean && \
    rm -rf                        \
    /var/lib/apt/lists/*          \
    /var/log/alternatives.log     \
    /var/log/apt/history.log      \
    /var/log/apt/term.log         \
    /var/log/dpkg.log             \
    /etc/machine-id               \
    /var/lib/dbus/machine-id

# Configure systemd.
#
# For running systemd inside a Docker container, some additional tweaks are
# required. For a detailed list see:
#
# https://developers.redhat.com/blog/2016/09/13/ \
#   running-systemd-in-a-non-privileged-container/
#
# Additional tweaks will be applied in the final image below.

# To avoid ugly warnings when running this image on a host running systemd, the
# following units will be masked.
#
# NOTE: This will not remove ALL warnings in all Debian releases, but seems to
#       work for stretch.
RUN systemctl mask --   \
    dev-hugepages.mount \
    sys-fs-fuse-connections.mount


# A different stop signal is required, so systemd will initiate a shutdown when
# running 'docker stop <container>'.
STOPSIGNAL SIGRTMIN+3

# The host's cgroup filesystem need's to be mounted (read-only) in the
# container. '/run', '/run/lock' and '/tmp' need to be tmpfs filesystems when
# running the container without 'CAP_SYS_ADMIN'.
#
# NOTE: For running Debian stretch, 'CAP_SYS_ADMIN' still needs to be added, as
#       stretch's version of systemd is not recent enough. Buster will run just
#       fine without 'CAP_SYS_ADMIN'.
VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock", "/tmp" ]

# As this image should run systemd, the default command will be changed to start
# the init system. CMD will be preferred in favor of ENTRYPOINT, so one may
# override it when creating the container to e.g. to run a bash console instead.
CMD [ "/sbin/init" ]