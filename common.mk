NAME=$(GROUP)/$(PREFIX)-$(SUFFIX)

build:
	docker build -t $(NAME) .

push:
	docker push $(NAME)

.PHONY: build push
