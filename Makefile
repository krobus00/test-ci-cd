include .env

# service name
SERVICE_NAME=${APP_NAME}
# default version is dev
VERSION?=dev
# docker image name
DOCKER_IMAGE_NAME=krobus00/${APP_NAME}

docker-image:
	docker build . -t $(DOCKER_IMAGE_NAME):$(VERSION) -f deployments/Dockerfile

push-image:
	docker push $(DOCKER_IMAGE_NAME):$(VERSION)

deploy:
	kubectl apply -k deployments/k8s

remove-container:
	kubectl delete service $(SERVICE_NAME)-service || true
	kubectl delete deployment $(SERVICE_NAME) || true

.PHONY: build-image deploy service