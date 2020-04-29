ARG TAG=latest
FROM debian:${TAG}

RUN apt-get update                                  \
    &&  apt-get install -y --no-install-recommends  \ 
        python3                                     \
        sudo                                        \
        bash                                        \
        ca-certificates                             \
        rsync                                       \
        iproute2                                    \
        python3-apt                                 \
    &&  apt-get clean                               \
    &&  rm -rf                                      \
        /var/lib/apt/lists/*                        \
        /var/log/alternatives.log                   \
        /var/log/apt/history.log                    \
        /var/log/apt/term.log                       \
        /var/log/dpkg.log                           ;
