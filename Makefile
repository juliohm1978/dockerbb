IMG=juliohm/dockerbb:2.2

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
	docker run -it --rm --name dockerbb \
		-e USER_UID=$(USER_UID) \
		-e USER_GID=$(USER_GID) \
		-e DESKTOP_SIZE=1366x900x16 \
		-p 6080:6080 \
		-v "$(HOME)/dockerbb-data:/home/user" \
		dockerbb www.bb.com.br

stop:
	-docker stop dockerbb
	-docker rm  -f dockerbb
