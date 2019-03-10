#
# This is the root Makefile for ensuring that the containers are all built
# properly

# GROUP can be overridden in the environment to root the docker images under
# different registry namespace
GROUP?=jenkins
# PREFIX defaults to `jnlp-agent` and can be changed to compute different image
# names
PREFIX?=jnlp-agent

build:
	for d in $$(find . -name Dockerfile -type f); do \
		name=$$(echo $$(dirname $$d) | cut -b 3- ); \
		docker build -t $(GROUP)/$(PREFIX)-$${name} $${name}; \
	done;

check: build

clean:
	docker images -qf "reference=${GROUP}/${PREFIX}*" | xargs -r docker rmi


.PHONY: build check clean
