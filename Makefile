TAG=robotframework

docker-build:
	docker build . -t "${TAG}"

docker-run:
	docker run -it --rm -v "${PWD}"/app:/app:ro -v "${PWD}"/tmp:/temp -w /app "${TAG}"

docker-run-test:
	docker run --rm -v "${PWD}"/app:/app:ro -v "${PWD}"/tmp:/temp -w /app --entrypoint ./entrypoint.sh "${TAG}"
