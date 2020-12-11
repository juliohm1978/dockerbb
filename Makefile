IMG=juliohm/dockerbb:3.3

DOCKERCMD="docker"

.PHONY: docs

USER_UID = $(shell id -u $(USER))
USER_GID = $(shell id -g $(USER))
ifeq ($(shell uname),Darwin)
	USER_GID = $(shell id -u $(USER))
endif

build:
	$(DOCKERCMD) build -t dockerbb .

push: build
	$(DOCKERCMD) tag dockerbb $(IMG)
	$(DOCKERCMD) push $(IMG)

start: IMG=dockerbb
start:
	-$(DOCKERCMD) stop dockerbb
	-$(DOCKERCMD) rm -f dockerbb
	#rm -rf ~/dockerbb-data/.config/chromium/Singleton*
	$(DOCKERCMD) run -d --rm -it --privileged --name dockerbb \
		-e USER_UID=$(USER_UID) \
		-e USER_GID=$(USER_GID) \
		-p 127.0.0.1:6080:6080 \
		-v "$(HOME)/dockerbb-data:/home/user" \
		$(IMG) www.bb.com.br
	$(DOCKERCMD) logs -f dockerbb

stop:
	#rm -rf ~/dockerbb-data/.config/chromium/Singleton*
	-$(DOCKERCMD) stop dockerbb
	-$(DOCKERCMD) rm -f dockerbb
	@echo
	@echo OK! dockerbb foi desligado
	@echo

logs:
	$(DOCKERCMD) logs -f dockerbb

shell:
	$(DOCKERCMD) exec -it dockerbb bash
remove:
	-$(DOCKERCMD) image rm dockerbb

docs:
	git add docs; git commit -m 'docs'; git push
