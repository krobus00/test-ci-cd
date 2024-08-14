# include .env

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
	echo "Current branch: $$CURRENT_BRANCH"; \
	echo "Creating and switching to branch $$BRANCH_NAME"; \
	git add .; \
	if [ -n "$$(git status --porcelain)" ]; then \
		git commit -m "FAST DEPLOY"; \
		echo "Changes committed"; \
		git checkout -b $$BRANCH_NAME; \
		echo "Pushing branch $$BRANCH_NAME"; \
		git push origin $$BRANCH_NAME; \
		echo "Switching back to branch $$CURRENT_BRANCH"; \
		git checkout $$CURRENT_BRANCH; \
		git reset --soft HEAD~1; \
		git branch -D $$BRANCH_NAME; \
		echo "Branch $$BRANCH_NAME created, pushed, and reverted to $$CURRENT_BRANCH successfully"; \
	else \
		echo "No changes to commit"; \
		git checkout -b $$BRANCH_NAME; \
		echo "Pushing branch $$BRANCH_NAME"; \
		git push origin $$BRANCH_NAME; \
		echo "Switching back to branch $$CURRENT_BRANCH"; \
		git checkout $$CURRENT_BRANCH; \
		git branch -D $$BRANCH_NAME; \
	fi
