#
# This is the root Makefile for ensuring that the containers are all built
# properly

# GROUP can be overridden in the environment to root the docker images under
# different registry namespace
GROUP?=jenkins
# PREFIX defaults to `jnlp-agent` and can be changed to compute different image
# names
PREFIX?=jnlp-agent

# This will run a given make command passed in at the command line, but only if .PHONY commented out
build: build.run

push: push.run

test: test.run

lint: lint.run

%.run: 
	set -e; \
	for d in $$(find . -name Dockerfile -type f); do \
		name=$$(basename $$(dirname $$d)); \
		echo $${name}; \
		$(MAKE) -C $$(dirname $$d) $* GROUP=$(GROUP) PREFIX=$(PREFIX) SUFFIX=$$name; \
	done;


clean: clean.run
	docker images -qf "reference=${GROUP}/${PREFIX}*" | xargs -r docker rmi


.PHONY: lint build test push clean
