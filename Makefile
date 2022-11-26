.DEFAULT: build


# $(eval ARCH:=$(shell uname -m))
#  --build-arg "ARCH=${ARCH}"
build: ## Build the container
	docker build \
	-t yaleman/kubectl-with-jq:latest .
