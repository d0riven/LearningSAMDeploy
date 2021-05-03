# cmd/{APP} とすることで切り替え可能になる
APP := sample

# 必要があれば以下あたりのローカルの環境変数の引き渡しを行ってもよい
#-e AWS_PROFILE=$(AWS_PROFILE) -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)
SAM := docker run --rm \
  -v ~/.aws:/root/.aws \
  -v $(CURDIR):/work \
  -w /work \
  doriven/sam-cli-go:1.23.0 sam

template := cmd/$(APP)/template.yaml
output := cmd/$(APP)/output.yaml
dist := cmd/$(APP)/dist/$(APP)

.PHONY: test
test:
	go test ./...

.PHONY: deps
deps:
	go mod vendor

clean:
	rm -rf cmd/$(APP)/dist/

.PHONY: build
build: $(dist)
$(dist): cmd/$(APP)/main.go
	GOOS=linux GOARCH=amd64 go build -o $@ $<

.PHONY: deploy
deploy: test clean build $(output)
	$(SAM) deploy \
		-t $(template) \
		--debug \
		--s3-bucket doriven-lambda-artifacts \
		--s3-prefix learning-sam-ci-deploy/sample \
		--no-fail-on-empty-changeset \
		--capabilities CAPABILITY_IAM \
		--capabilities CAPABILITY_NAMED_IAM \
		--stack-name learning-sam-ci-deploy-sample \
		--parameter-overrides \
			HOGE=FUGAFUGA

.PHONY: $(output)
$(output):
	$(SAM) validate -t $(template)
	$(SAM) package \
		-t $(template) \
		--debug \
		--s3-bucket doriven-lambda-artifacts \
		--s3-prefix learning-sam-ci-deploy/sample \
		--output-template-file $@

