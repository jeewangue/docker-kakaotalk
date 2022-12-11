# docker-kakaotalk

Run Kakaotalk as a docker container on Linux (_finally_).

- This image runs Kakaotalk on wine on Ubuntu.
- Default Fonts are configured with easy-to-read NanumGothic Fonts.
- All installations and configurations are done on build.
- Base images are modified versions of [scottyhardy/docker-remote-desktop](https://github.com/scottyhardy/docker-remote-desktop) and [scottyhardy/docker-wine](https://github.com/scottyhardy/docker-wine).

## Usage

using `docker`:

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

using `docker-compose`:

```bash
docker-compose up
```

## Build

build process uses [buildx-bake](https://docs.docker.com/engine/reference/commandline/buildx_bake/) to combine multiple separated Dockerfiles into one target.

```bash
# to see the graph of build process
make print

# to build your own image from clean ubuntu
make build
```
