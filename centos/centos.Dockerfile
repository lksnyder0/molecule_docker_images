ARG TAG=latest
ARG BASEIMAGE=centos
FROM ${BASEIMAGE}:${TAG}

RUN if [ $(command -v dnf) ]; then                      \
        dnf makecache --timer                           &&\
        dnf --assumeyes install                         \
            python3                                     \
            sudo                                        \
            python3-devel                               \
            python3-dnf                                 \
            bash                                        \
            rsync                                       \
            iproute                                     &&\
        dnf clean all;                                  \
    elif [ $(command -v yum) ]; then                    \
        yum makecache fast                              &&\
        yum install -y                                  \
            python3                                     \
            sudo                                        \
            yum-plugin-ovl                              \
            bash                                        \
            rsync                                       \
            iproute                                     &&\
        sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf  &&\
        yum clean all                                   ;\
    fi
