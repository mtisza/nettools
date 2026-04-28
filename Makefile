#########################################################
# build the container
#########################################################
DOCKER_REPO ?= docker.io
DOCKER_IMAGE ?= mtisza/nettools
DOCKER_CONFIG_DIR ?= $(HOME)/.docker
GIT_HASH ?= $(or $(shell git log --format="%h" -n 1 2>/dev/null),dev)

ifeq ("${V}","1")
DOCKER_VERBOSE := --progress=plain
endif

.PHONY: all build build-local release

all: build

build-local:
	@if ! docker buildx inspect mybuilder > /dev/null 2>&1; then \
		docker buildx create --name mybuilder --use; \
	else \
		docker buildx use mybuilder; \
	fi
	docker buildx build \
		${DOCKER_VERBOSE} \
		--load \
		--tag ${DOCKER_REPO}/${DOCKER_IMAGE}:${GIT_HASH} \
		.

build:
	@if ! docker buildx inspect mybuilder > /dev/null 2>&1; then \
		docker buildx create --name mybuilder --use; \
	else \
		docker buildx use mybuilder; \
	fi
	docker buildx build \
		${DOCKER_VERBOSE} \
		--provenance=true \
		--sbom=true \
		--platform linux/amd64,linux/arm64 \
		--tag ${DOCKER_REPO}/${DOCKER_IMAGE}:${GIT_HASH} \
		--push \
		.

release:
	docker run --rm \
		--user $(shell id -u):$(shell id -g) \
		-v $(DOCKER_CONFIG_DIR):/.docker:ro \
		-e DOCKER_CONFIG=/.docker \
		regclient/regctl:latest \
		image copy \
		$(DOCKER_REPO)/$(DOCKER_IMAGE):$(GIT_HASH) \
		$(DOCKER_REPO)/$(DOCKER_IMAGE):latest