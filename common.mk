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

IMAGE_TAR?=$(SUFFIX)-image.tar

ROOT_DIR?=$(dir $(lastword $(MAKEFILE_LIST)))

ABS_ROOT_DIR=$(realpath $(ROOT_DIR))

NAME=$(GROUP)/$(PREFIX)-$(SUFFIX)

build: lint
	docker build -t $(NAME) .

lint:
	@docker run --rm -i hadolint/hadolint:v1.19.0 < Dockerfile || echo "== Lint Tests for $(SUFFIX) ⚠️  Did Not Succeed"

test: $(IMAGE_TAR)
	@docker run --rm --volume="$(ABS_ROOT_DIR):$(ABS_ROOT_DIR)" --workdir="$(shell pwd)" gcr.io/gcp-runtimes/container-structure-test:v1.10.0 test --driver=tar --image=$(IMAGE_TAR) --config=$(ROOT_DIR)/cst.yml

clean:
	rm -f *.tar

push:
	docker load $(IMAGE_TAR)
	docker push $(NAME)

$(IMAGE_TAR): build
	docker save --output $(IMAGE_TAR) $(NAME)

.PHONY: lint build test push clean
