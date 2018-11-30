build:
	docker build -t dockerbb --force-rm .

squash:
	docker build -t dockerbb --squash --force-rm .

dev:
	docker build -t dockerbb .

run:
	-docker stop dockerbb
	-docker rm dockerbb
	docker run --rm -it --name dockerbb \
		--shm-size 100m \
		--net host \
		--hostname $(shell hostname) \
		-e XSOCK \
		-e XAUTH \
		-e DISPLAY \
		-v "$(HOME)/.Xauthority:/root/.Xauthority:rw" \
		--cap-add SYS_ADMIN \
		-v "$(HOME)/dockerbb-data:/home/user" \
		dockerbb www.bb.com.br
