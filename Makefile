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
	rm -rf test/test_app/
	cd test && yes | mix phx.new --no-ecto test_app