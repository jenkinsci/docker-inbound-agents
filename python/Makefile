NAME=$(GROUP)/$(PREFIX)-python

build:
	docker build -t $(NAME) .
	docker build -t $(NAME):2 -f Dockerfile.python2 .

push:
	docker push $(NAME)
	docker push $(NAME):2


.PHONY: build push
