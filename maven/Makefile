NAME=$(GROUP)/$(PREFIX)-maven

build:
	docker build -t $(NAME) .
	docker build -t $(NAME):jdk11 -f Dockerfile.jdk11 .

push:
	docker push $(NAME)
	docker push $(NAME):jdk11


.PHONY: build push
