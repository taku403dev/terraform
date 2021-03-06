init:
	curl https://www.toptal.com/developers/gitignore/api/terraform > .gitignore \
	&& curl https://www.toptal.com/developers/gitignore/api/node >> .gitignore \
	&& curl https://www.toptal.com/developers/gitignore/api/yarn >> .gitignore \
	&& echo 'src/' >> .gitignore \
	&& echo '.tfenv/' >> .gitignore \
	&& echo '.envrc' >> .gitignore \
	&& mkdir -p tmp/log \
	&& mkdir src \
	&& tfenv install

gitignore:
	curl https://www.toptal.com/developers/gitignore/api/terraform  > .gitignore \
	&& curl https://www.toptal.com/developers/gitignore/api/node >> .gitignore \
	&& curl https://www.toptal.com/developers/gitignore/api/yarn >> .gitignore \
	&& echo 'src/' >> .gitignore \
	&& echo '.tfenv/' >> .gitignore \
	&& echo '.envrc' >> .gitignore

run-deploy:
	terraform fmt \
	&& terraform plan \
	&& terraform apply -auto-approve

create-ssh-keygen:
	ssh-keygen -t rsa -b 2048 -f tastylog-dev-keypair \
	&& mv tastylog-dev-keypair tastylog-dev-keypair.pem \
	&& mkdir ./src \
	&& mv tastylog-dev-keypair.pem tastylog-dev-keypair.pub ./src/
