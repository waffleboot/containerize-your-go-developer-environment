target = bin

all:
	export DOCKER_BUILDKIT=1; \
	docker build --target $(target) --output bin/ .
