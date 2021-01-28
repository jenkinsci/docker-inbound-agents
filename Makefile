#
# This is the root Makefile for ensuring that the containers are all built
# properly

# GROUP can be overridden in the environment to root the docker images under
# different registry namespace
GROUP?=jenkinsciinfra
# PREFIX defaults to `inbound-agent` and can be changed to compute different image
# names
PREFIX?=inbound-agent

# This will run a given make command passed in at the command line, but only if .PHONY commented out
build: build.run
	@echo "== All Builds ✅ Succeeded"

push: push.run
	@echo "== All Pushes ✅ Succeeded"

test: test.run
	@echo "== All Tests ✅ Succeeded"

lint: lint.run

%.run:
	set -e; \
	for d in $$(find . -name Dockerfile -type f); do \
		name=$$(basename $$(dirname $$d)); \
		$(MAKE) -C $$(dirname $$d) $* GROUP=$(GROUP) PREFIX=$(PREFIX) SUFFIX=$$name; \
	done;

clean: clean.run
	docker images -qf "reference=${GROUP}/${PREFIX}*" | xargs -r docker rmi


.PHONY: lint build test push clean
