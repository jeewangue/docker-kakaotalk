export DOCKER_BUILDKIT   := 1
export BUILDKIT_PROGRESS := plain

.PHONY: all
all: build

.PHONY: print
print:
	@TAG=$$(date +"%Y%m%d") docker buildx bake --print

.PHONY: build
build:
	@TAG=$$(date +"%Y%m%d") docker buildx bake --load

.PHONY: push
push:
	@TAG=$$(date +"%Y%m%d") docker buildx bake --push

