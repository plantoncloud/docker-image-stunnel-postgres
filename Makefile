version?=v0.0.1
docker_image_repo=us-central1-docker.pkg.dev/planton-shared-services-2w/planton-pcs-docker-repo-external
docker_image_path=github.com/plantoncloud/docker-image-stunnel-postgres
docker_image_tag?=${version}
docker_image=${docker_image_repo}/${docker_image_path}:${docker_image_tag}

.PHONY: build
build:
	docker build --platform linux/amd64 -t ${docker_image} .

.PHONY: release
release: build
	docker push ${docker_image}

.PHONY: tag
tag:
	git tag ${docker_image_tag}
	git push origin ${docker_image_tag}
