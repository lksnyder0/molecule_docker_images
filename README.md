# molecule_docker_images

## Images published

- lksnyder0/docker:latest, lksnyder0/docker:10, lksnyder0/docker:buster
- lksnyder0/docker:11, lksnyder0/docker:bullseye
- lksnyder0/docker_systemd:latest, lksnyder0/docker_systemd:10, lksnyder0/docker_systemd:buster
- lksnyder0/docker_systemd:11, lksnyder0/docker_systemd:bullseye

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
```
