TAG=robotframework

docker-build:
	docker build . -t "${TAG}"

docker-run:
	docker run -it --rm -v "${PWD}"/app:/app:ro -v "${PWD}"/temp:/temp \
	-v "${PWD}"/entrypoint.sh:/entrypoint.sh:ro "${TAG}"

docker-run-test:
	docker run --rm -v "${PWD}"/app:/app:ro -v "${PWD}"/temp:/temp \
	-v "${PWD}"/entrypoint.sh:/entrypoint.sh:ro --entrypoint ./entrypoint.sh "${TAG}"
