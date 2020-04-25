IMG=juliohm/dockerbb:2.3

USER_UID = $(shell id -u $(USER))
ifeq ($(shell uname),Darwin)
    USER_GID = $(shell id -u $(USER))
else
    USER_GID = $(shell id -g $(USER))
endif

build:
	docker build -t dockerbb .

push: build
	docker tag dockerbb $(IMG)
	docker push $(IMG)

start: IMG=dockerbb
ifeq ($(shell uname),Darwin)
start:
	-docker stop dockerbb
	-docker rm -f dockerbb
	rm -rf ~/dockerbb-data/.config/chromium/Singleton*
	docker run -e MACOS=1 -d --stop-timeout 0 --privileged --name dockerbb \
		-e USER_UID=$(USER_UID) \
		-e USER_GID=$(USER_GID) \
		-p 127.0.0.1:6080:6080 \
		-v "$(HOME)/dockerbb-data:/home/user" \
		$(IMG) www.bb.com.br
	docker logs -f dockerbb
else
	-docker stop dockerbb
	-docker rm -f dockerbb
	docker run -d --stop-timeout 0 --privileged --name dockerbb \
		-e USER_UID=$(USER_UID) \
		-e USER_GID=$(USER_GID) \
		-p 127.0.0.1:6080:6080 \
		-v "$(HOME)/dockerbb-data:/home/user" \
		$(IMG) www.bb.com.br
	docker logs -f dockerbb
endif

stop:
ifeq ($(shell uname),Darwin)
	rm -rf ~/dockerbb-data/.config/chromium/Singleton*
endif
	-docker stop -t0 dockerbb
	-docker rm  -f dockerbb

logs:
	docker logs -f dockerbb

shell:
	docker exec -it dockerbb bash
remove:
	-docker image rm dockerbb
