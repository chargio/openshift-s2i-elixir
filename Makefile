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
	echo "Deleting test directory"
	# rm -rf test/test_app/
	echo "Generating new example without Database"
	# cd test && yes | mix phx.new --no-ecto test_app
	echo "Starting in this directory:"
	pwd 
	echo "Making sure that the secret file is not ignored"
	sed -ie '/secret\.exs/s/^/#/g'  test/test_app/.gitignore 
	echo "Opening the ports in production for the container $PORT"
	sed -ie '/host: "example.com", port: 80/ip: {0, 0, 0,0}, port: 4000/g' test/test_app/config/prod.exs
