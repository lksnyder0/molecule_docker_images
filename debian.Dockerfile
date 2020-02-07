ARG TAG=latest
FROM debian:${TAG}

RUN apt-get update && apt-get install -y python sudo bash ca-certificates iproute2 && apt-get clean;