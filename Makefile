IMG=juliohm/dockerbb:2.3

USER_UID = $(shell id -u $(USER))
USER_GID = $(shell id -g $(USER))

build:
	docker build -t dockerbb .

push: build
	docker tag dockerbb $(IMG)
	docker push $(IMG)

start:
	-docker stop dockerbb
	-docker rm -f dockerbb
	docker run -d --stop-timeout 0 --privileged --name dockerbb \
		-e USER_UID=$(USER_UID) \
		-e USER_GID=$(USER_GID) \
		-p 127.0.0.1:6080:6080 \
		-v "$(HOME)/dockerbb-data:/home/user" \
		dockerbb www.bb.com.br
	docker logs -f dockerbb

stop:
	-docker stop -t0 dockerbb
	-docker rm  -f dockerbb

shell:
	docker logs -f dockerbb

shell:
	docker exec -it dockerbb bash
