IMAGE_NAME = phoenix-s2i-builder
PORT = 4000

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run

.PHONY: test_example
test_example:
	echo "Deleting test directory"
	rm -rf test/test_app/
	echo "Generating new example without Database"
	cd test && yes | mix phx.new --no-ecto test_app
	echo "Starting in this directory:"
	pwd 
	echo "Making sure that the secret file is not ignored"
	sed -i '.bak' 's|.*\*.secret\.exs|# &|' test/test_app/.gitignore
	rm test/test_app/.gitignore.bak
	echo "Opening the ports in production for the container port $(PORT)"
	sed -i '.bak' 's/host: \"example.com\", port: 80/ip: {0, 0, 0, 0}, port: $(PORT)/' test/test_app/config/prod.exs
	rm test/test_app/config/prod.exs.bak