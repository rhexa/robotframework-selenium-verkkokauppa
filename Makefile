TAG=robotframework

docker-build:
	docker build . -t "${TAG}"

docker-run:
	docker run -it --rm -v "${PWD}"/main:/app/main:ro "${TAG}"
