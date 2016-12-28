VERSION=1.3.1
NAMESPACE=seanhoughton
TAG=$(VERSION)
UNAME_A=$(shell uname -a)

ifneq (,$(findstring raspberrypi,$(UNAME_A)))
    NAME=rpi-indiserver
    DOCKERFILE=Dockerfile.rpi
else
    NAME=indiserver
    DOCKERFILE=Dockerfile.x86
endif

.PHONY: image push run
default: image

image:
	docker build -t $(NAMESPACE)/$(NAME):$(TAG) -f $(DOCKERFILE) .

push: image
	docker push $(NAMESPACE)/$(NAME):$(TAG)


