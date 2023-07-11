project_name = docker-local-nginx
image_name = docker-local-nginx:latest

hello:
	make delete-container-if-exist
	make build
	make up-default

up:
	make certs
	make delete-container-if-exist
	make build
	make up-compose

certs:
	mkdir -p ~/.certs && cd ~/.certs && mkcert localhost
	cd ~/.certs && openssl pkcs12 -inkey localhost-key.pem -in localhost.pem -export -out localhost.pfx -passout pass:

build:
	docker build -t $(image_name) .

# Useful for CI
build-no-cache:
	docker build --no-cache -t $(image_name) .

# Will use a generate certificate as fallback to demonstrate functionality
up-default:
	docker run -p 80:80 -p 443:443 -e TARGET_SERVER="http://host.docker.internal:4000" --name $(project_name) $(image_name)

# Use credentials stored under $HOME/.certs
up-compose:
	docker compose up

delete-container-if-exist:
	docker stop $(project_name) || true && docker rm -f $(project_name) || true

shell:
	docker exec -it $(project_name) /bin/sh

stop:
	docker stop $(project_name)

start:
	docker start $(project_name)
