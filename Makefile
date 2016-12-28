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

.PHONY: image
default: image

image:
	docker build -t $(NAMESPACE)/$(NAME):$(TAG) -f $(DOCKERFILE) .

push:
	docker push $(NAMESPACE)/$(NAME):$(TAG)
sbig:
	docker run --privileged -v /dev/bus/usb:/dev/bus/usb -d -p 7624:7624 $(NAMESPACE)/$(NAME):$(TAG) indi_sbig_ccd
