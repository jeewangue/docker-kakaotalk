# docker-kakaotalk

```bash
x11docker --xephyr --printenv --xoverip --xauth=no --display=30
```

```bash
docker build --build-arg DISPLAY=172.17.0.2:30 --network=host -t jeewangue/docker-kakaotalk .
```

```bash
docker run -it \
  --rm \
  --ipc host \
  --hostname="$(hostname)" \
  --env="DISPLAY" \
  --volume="${XAUTHORITY:-${HOME}/.Xauthority}:/root/.Xauthority:ro" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:ro" \
  jeewangue/docker-kakaotalk
```
