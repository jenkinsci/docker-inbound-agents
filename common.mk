#
## The following variables are defined to allow building a single directory
## without running the whole Makefile infrastructure, e.g. `make -C node`
#
# GROUP can be overridden in the environment to root the docker images under
# different registry namespace
GROUP?=jenkins
# PREFIX defaults to `jnlp-agent` and can be changed to compute different image
# names
PREFIX?=jnlp-agent
# SUFFIX defaults to the directory name
SUFFIX?=$(shell basename $(shell pwd))

NAME=$(GROUP)/$(PREFIX)-$(SUFFIX)

build:
	docker build -t $(NAME) .

lint:
	echo $(NAME)-lint

test:
	echo test

push:
	docker push $(NAME)

.PHONY: lint build test push
