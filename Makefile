init:
	curl https://www.toptal.com/developers/gitignore/api/terraform > .gitignore \
	&& curl https://www.toptal.com/developers/gitignore/api/node >> .gitignore \
	&& terraform init

gitignore:
	curl https://www.toptal.com/developers/gitignore/api/terraform  > .gitignore \
	&& curl https://www.toptal.com/developers/gitignore/api/node >> .gitignore
