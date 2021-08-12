# this was seeded from https://github.com/umsi-mads/education-notebook/blob/master/Makefile
# by way of jappavoo/bu-cs-book-dev
.PHONY: help build dev test test-env

# Docker image name and tag=
IMAGE:=mcrovella/bu-cs-basic-book-dev
TAG?=latest
# Shell that make should use
SHELL:=bash
# force no caching for docker builds
#DCACHING=--no-cache

# we mount here to match operate first
MOUNT_DIR=/opt/app-root/src
HOST_DIR=${HOME}
help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


base-build: DARGS?=
base-build: INAME=$(IMAGE)-base
base-build: ## Make the base image
	docker build $(DARGS) $(DCACHING) --rm --force-rm -t $(INAME):$(TAG) .

base-push: DARGS?=
base-push: INAME?=$(IMAGE)-base
base-push: ## push base image
	docker push $(INAME):$(TAG)

base-root: INAME=$(IMAGE)-base
base-root: ARGS?=/bin/bash
base-root: DARGS?=-u 0
base-root: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(INAME):$(TAG) $(ARGS)

base-jovyan: INAME=$(IMAGE)-base
base-jovyan: ARGS?=/bin/bash
base-jovyan: DARGS?=
base-jovyan: ## start container with user shell 
	docker run -it --rm $(DARGS) $(INAME):$(TAG) $(ARGS)

base-lab: INAME=$(IMAGE)-base
base-lab: ARGS?=
base-lab: DARGS?=-e JUPYTER_ENABLE_LAB=yes -v "${HOST_DIR}":"${MOUNT_DIR}"
base-lab: PORT?=8888
base-lab: ## start a jupyter lab notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(INAME):$(TAG) $(ARGS)

base-nb: INAME=$(IMAGE)-base
base-nb: ARGS?=
base-nb: DARGS?=-v "${HOST_DIR}":"${MOUNT_DIR}"
base-nb: PORT?=8888
base-nb: ## start a jupyter classic notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(INAME):$(TAG) $(ARGS) 

build: DARGS?=
build: ## Make the latest build of the image
	docker build $(DARGS) $(DCACHING) --rm --force-rm -t $(IMAGE):$(TAG) .

push: DARGS?=
push: ## push latest container image to dockerhub
	docker push $(IMAGE):$(TAG)

root: ARGS?=/bin/bash
root: DARGS?=-u 0
root: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(IMAGE):$(TAG) $(ARGS)

jovyan: ARGS?=/bin/bash
jovyan: DARGS?=
jovyan: ## start container with user shell 
	docker run -it --rm $(DARGS) $(IMAGE):$(TAG) $(ARGS)

#docker run --rm -e JUPYTER_ENABLE_LAB=yes -p 8888:8888 -v "${HOME}":/home/jovyan/work  jappavoo/bu-cs-book-dev:latest
lab: ARGS?=
lab: DARGS?=-e JUPYTER_ENABLE_LAB=yes -v "${HOST_DIR}":"${MOUNT_DIR}"
lab: PORT?=8888
lab: ## start a jupyter lab notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(IMAGE):$(TAG) $(ARGS)

nb: ARGS?=
nb: DARGS?=-v "${HOST_DIR}":"${MOUNT_DIR}"
nb: PORT?=8888
nb: ## start a jupyter classic notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(IMAGE):$(TAG) $(ARGS) 

