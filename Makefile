TEMPLATE_FILE = src/cloudformation/root.yml
STACK_NAME = data-transfer-test
BUCKET = cfn-build-objects
PROFILE = tohi.work-admin
PROJECT = data-transfer-test

package:
	mkdir -p build
	aws cloudformation package --template-file $(TEMPLATE_FILE) --s3-bucket $(BUCKET) --output-template-file build/template.yml --region ap-northeast-1 --profile $(PROFILE)

deploy:
	aws cloudformation deploy --template-file ./build/template.yml \
	--stack-name $(STACK_NAME) \
	--region ap-northeast-1 --profile $(PROFILE) \
	--capabilities CAPABILITY_NAMED_IAM \
	--parameter-overrides `cat ${PWD}/src/cloudformation/param.json | jq -r '.Parameters | to_entries | map("\(.key)=\(.value|tostring)") | .[]' | tr '\n' ' ' | awk '{print}'`

infra: package deploy

confirm:
	@read -p "Delete $(STACK_NAME) ?[y/N]: " ans; \
        if [ "$$ans" != y ]; then \
                exit 1; \
        fi

delete: confirm
	aws cloudformation delete-stack \
	--stack-name $(STACK_NAME) \
	--region ap-northeast-1 \
	--profile $(PROFILE)\

test:
	aws s3 cp  ./data/sample.txt s3://data-receive-test/data/ --profile tohi.work-admin