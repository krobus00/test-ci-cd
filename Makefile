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

fast-deploy:
	@CURRENT_TIME=$$(date +%Y%m%d%H%M%S); \
	BRANCH_NAME="fast-deployment/$$CURRENT_TIME"; \
	CURRENT_BRANCH=$$(git rev-parse --abbrev-ref HEAD); \
	echo "Creating and switching to branch $$BRANCH_NAME"; \
	git checkout -b $$BRANCH_NAME; \
	if [ -n "$$(git status --porcelain)" ]; then \
		echo "Committing changes"; \
		git add .; \
		git commit -m "FAST DEPLOY"; \
	fi; \
	echo "Pushing branch $$BRANCH_NAME"; \
	git push origin $$BRANCH_NAME; \
	echo "Switching back to branch $$CURRENT_BRANCH"; \
	git checkout $$CURRENT_BRANCH; \
	echo "Branch $$BRANCH_NAME created, pushed, and reverted to $$CURRENT_BRANCH successfully"
