IMAGE_NAME = phoenix-s2i-builder

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run

.PHONY: test_example
test_example:
	cd test
	rm -rf test_app/
	yes | mix phx.new --no-ecto test_app