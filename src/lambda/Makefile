ROLE = arn:aws:iam::665378081513:role/data-transfer-test-function-execution-role
PROFILE = tohi.work-admin

create:
	aws lambda create-function \
		--function-name bash-runtime \
		--zip-file fileb://function-only.zip \
		--handler function.handler \
		--runtime provided \
		--role  $(ROLE) \
		--layers $(LAYER) \
		--profile $(PROFILE)

update:
	zip function-only.zip function.sh
	aws lambda update-function-code \
		--function-name bash-runtime \
		--zip-file fileb://function-only.zip \
		--profile $(PROFILE)

