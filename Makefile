include env_make
NS = registry.blakenet.uk/sdr
INSTANCE = v0.1
VERSION ?= $(INSTANCE).1

REPO = sdr
NAME = sdr_$(INSTANCE)
VOL_DATA = sdr_logs_$(INSTANCE)
VOL_BASE = /data
VOL_PATH = /data/logs

.PHONY: build push logs release start stop volume-delete volume-create init volume-backup-restore volume-backup exec-bash exec-bash-vol


build:
	docker build -t $(NS)/$(REPO):$(VERSION) .
	docker tag -f $(NS)/$(REPO):$(VERSION) $(NS)/$(REPO):latest

push:
	docker push $(NS)/$(REPO):$(VERSION)

logs:
	docker logs $(NAME)

release: build
	make push -e VERSION=$(VERSION)

default: build

run: stop
	docker run --rm --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

start: stop
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

stop:
	-docker stop $(NAME)
	-docker rm -f $(NAME)

volume-delete: stop
	-docker rm -f $(VOL_DATA)

volume-create: volume-delete
	docker create --name $(VOL_DATA) -v $(VOL_PATH) $(NS)/$(REPO):$(VERSION) /bin/true

init: volume-create
	make start

volume-restore: volume-create
	cat backup.tgz | gunzip | docker cp - $(VOL_DATA):$(VOL_BASE)
	make start

volume-backup: stop
	docker cp $(VOL_DATA):$(VOL_PATH) - | gzip > backup-$(VOL_DATA)-`date +%Y-%m-%d"_"%H_%M_%S`.tgz
	make start

exec-bash:
	docker exec -it $(NAME) bash

exec-bash-vol:
	docker run -it --name $(NAME)_bash $(PORTS) --volumes-from ${VOL_DATA} $(ENV) --entrypoint="/bin/bash" $(NS)/$(REPO):$(VERSION)
	docker rm -f $(NAME)_bash
