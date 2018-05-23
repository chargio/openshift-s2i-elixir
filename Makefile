IMAGE_NAME = phoenix-s2i-builder

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run

.PHONY: build_test_example
example:
	cd test
	yes | mix phx.new --no-ecto phx_test