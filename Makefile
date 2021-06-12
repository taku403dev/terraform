init:
	curl https://www.toptal.com/developers/gitignore/api/terraform > .gitignore \
	&& curl https://www.toptal.com/developers/gitignore/api/node >> .gitignore \
	&& terraform init

gitignore:
	curl https://www.toptal.com/developers/gitignore/api/terraform  > .gitignore \
	&& curl https://www.toptal.com/developers/gitignore/api/node >> .gitignore

run-deploy:
	terraform fmt \
	&& terraform plan \
	&& terraform apply -auto-approve
