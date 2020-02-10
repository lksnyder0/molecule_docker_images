# molecule_docker_images

## Images published

- lksnyder0/debian:latest, lksnyder0/debian:10, lksnyder0/debian:buster
- lksnyder0/debian:11, lksnyder0/debian:bullseye
- lksnyder0/debian_systemd:latest, lksnyder0/debian_systemd:10, lksnyder0/debian_systemd:buster
- lksnyder0/debian_systemd:11, lksnyder0/debian_systemd:bullseye
- lksnyder0/centos:latest, lksnyder0/centos:8
- lksnyder0/centos:7
- lksnyder0/centos_systemd:latest, lksnyder0/centos_systemd:8
- lksnyder0/centos_systemd:7

## Example Molecule Platform Configuration

```yaml
platforms:
  - name: debian10
    image: "lksnyder0/debian:10"
  - name: debian10_systemd
    image: "lksnyder0/debian_systemd:10"
    privileged: True
    volumes:
      - "/sys/fs/cgroup:/sys/fs/cgroup:ro"
    tty: True
    environment:
      container: docker
    command: "/sbin/init"
    pre_build_image: True
  - name: centos8_systemd
    image: "lksnyder0/centos_systemd:8"
    privileged: True
    volumes:
      - "/sys/fs/cgroup:/sys/fs/cgroup:ro"
    tty: True
    environment:
      container: docker
    command: "/usr/sbin/init"
    pre_build_image: True

```
