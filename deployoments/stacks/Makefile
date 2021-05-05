SCOPE := sample

S3_BUCKET := doriven-tfstates
AWS_PROFILE := default
AWS_DEFAULT_REGION := ap-northeast-1

TF := docker run -it --rm \
	-v ~/.aws:/root/.aws \
	-v $(CURDIR):/work \
	-w /work/$(SCOPE) \
	-e AWS_PROFILE=$(AWS_PROFILE) \
	-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) \
	hashicorp/terraform:0.15.1

.PHONY: plan
plan: init
	$(TF) plan

.PHONY: apply
apply: init
	$(TF) apply -auto-approve=false

.PHONY: import state
ADDR :=
ID :=
import: init
	$(TF) import $(ADDR) $(ID)
state:
	$(TF) state show $(ADDR)

.PHONY: init
init: terraform_remote_s3_key = learning-sam-ci-deploy/$(shell echo "$(SCOPE)" | sed -e 's/\(\/\)*$$//g')/terraform.tfstate
init: fmt
	$(TF) init \
		-reconfigure \
		-get=true \
		-backend=true \
		-backend-config="bucket=$(S3_BUCKET)" \
		-backend-config="key=$(terraform_remote_s3_key)" \
		-backend-config="region=$(AWS_DEFAULT_REGION)" \
		-backend-config="profile=$(AWS_PROFILE)"

.PHONY: fmt
fmt:
	$(TF) fmt
