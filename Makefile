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
	set -e; \
	for d in $$(find . -name Dockerfile -type f); do \
		name=$$(echo $$(dirname $$d) | cut -b 3- ); \
		$(MAKE) -C $$name GROUP=$(GROUP) PREFIX=$(PREFIX) SUFFIX=$$name; \
	done;

push: build
	set -e; \
	for d in $$(find . -name Dockerfile -type f); do \
		name=$$(echo $$(dirname $$d) | cut -b 3- ); \
		$(MAKE) -C $$name push GROUP=$(GROUP) PREFIX=$(PREFIX) SUFFIX=$$name; \
	done;

check: build

clean:
	docker images -qf "reference=${GROUP}/${PREFIX}*" | xargs -r docker rmi


.PHONY: build check clean
