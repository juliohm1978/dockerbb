IMG=juliohm/dockerbb:3.2

.PHONY: docs

USER_UID = $(shell id -u $(USER))
USER_GID = $(shell id -g $(USER))
ifeq ($(shell uname),Darwin)
	USER_GID = $(shell id -u $(USER))
endif

build:
	docker build -t dockerbb .

push: build
	docker tag dockerbb $(IMG)
	docker push $(IMG)

start: IMG=dockerbb
start:
	-docker stop dockerbb
	-docker rm -f dockerbb
	rm -rf ~/dockerbb-data/.config/chromium/Singleton*
	docker run -d --rm -it --privileged --name dockerbb \
		-e USER_UID=$(USER_UID) \
		-e USER_GID=$(USER_GID) \
		-p 127.0.0.1:6080:6080 \
		-v "$(HOME)/dockerbb-data:/home/user" \
		$(IMG) www.bb.com.br
	docker logs -f dockerbb

stop:
	rm -rf ~/dockerbb-data/.config/chromium/Singleton*
	-docker stop dockerbb
	-docker rm -f dockerbb
	@echo
	@echo OK! dockerbb foi desligado
	@echo

logs:
	docker logs -f dockerbb

shell:
	docker exec -it dockerbb bash
remove:
	-docker image rm dockerbb

docs:
	git add docs; git commit -m 'docs'; git push