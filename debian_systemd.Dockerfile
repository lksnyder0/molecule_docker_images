# Inspired by https://github.com/alehaa/docker-debian-systemd/blob/master/Dockerfile
ARG TAG=latest
ARG BASEIMAGE=lksnyder0/debian
FROM ${BASEIMAGE}:${TAG}

ENV container docker

RUN echo 'debconf debconf/frontend select teletype' | debconf-set-selections

RUN apt-get update              &&                  \
    &&  apt-get install -y --no-install-recommends  \
        systemd                                     \
        systemd-sysv                                \
        cron                                        \
        anacron                                     \
    &&  apt-get clean                               \
    &&  rm -rf                                      \
        /var/lib/apt/lists/*                        \
        /var/log/alternatives.log                   \
        /var/log/apt/history.log                    \
        /var/log/apt/term.log                       \
        /var/log/dpkg.log                           \
        /etc/machine-id                             \
        /var/lib/dbus/machine-id                    ;

RUN systemctl mask --   \
    dev-hugepages.mount \
    sys-fs-fuse-connections.mount

STOPSIGNAL SIGRTMIN+3

VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock", "/tmp" ]

CMD [ "/sbin/init" ]