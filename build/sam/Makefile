REPO := doriven/sam-cli
TAG := 1.23.0

.PHONY: build
build:
	docker build -t $(REPO):$(TAG) ./

.PHONY: release login
release: build login
	docker push $(REPO):$(TAG)

login:
	docker login