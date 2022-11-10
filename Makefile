v?=v0.0.1
docker_image_repo=us-central1-docker.pkg.dev/planton-shared-services-2w/planton-pcs-docker-repo-external
docker_image_path=gitlab.com/plantoncode/planton/oss/docker-images/stunnel-postgres
docker_image_tag?=${v}
docker_image=${docker_image_repo}/${docker_image_path}:${docker_image_tag}

.PHONY: build
build:
	docker build --platform linux/amd64 -t ${docker_image} .

.PHONY: release
release: build
	docker push ${docker_image}
