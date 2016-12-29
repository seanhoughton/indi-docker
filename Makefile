VERSION=1.3.1
NAMESPACE=seanhoughton
TAG=$(VERSION)
UNAME_A=$(shell uname -a)

ifneq (,$(findstring raspberrypi,$(UNAME_A)))
    NAME=rpi-indiserver
    DOCKERFILE=Dockerfile.rpi
    DRIVERS_TO_INSTALL=libsbigudrv2_2.1.1_armhf.deb libqhy_0.1.8_armhf.deb
    IMAGE_DEPS=ibindi-rpi.tgz
else
    NAME=indiserver
    DOCKERFILE=Dockerfile.x86
    DRIVERS_TO_INSTALL=libsbigudrv2 libqhy
endif

.PHONY: image push installdrivers-rpi rpi-indiserver-bootstrap indiserver-bootstrap bootstrap
default: image


libindi-rpi.tgz:
	# note: the version isn't part of the URL so this might not always work...
	curl http://indilib.org/download/raspberry-pi/send/6-raspberry-pi/9-indi-library-for-raspberry-pi.html > libindi-rpi.tgz

image: $(IMAGE_DEPS)
	docker build -t $(NAMESPACE)/$(NAME):$(TAG) -f $(DOCKERFILE) .

push: image
	docker push $(NAMESPACE)/$(NAME):$(TAG)

rpi-indiserver-bootstrap: libindi-rpi.tgz
	sudo apt-get update && sudo apt-get install -y docker-engine fxload
	tar -C /tmp -xzf libindi-rpi.tgz
	cd /tmp/libindi_$(VERSION)_rpi && sudo dpkg -i $(DRIVERS_TO_INSTALL) && rm -r /tmp/libindi_$(VERSION)_rpi

indiserver-bootstrap:
	sudo apt-get update && sudo apt-get install -y docker-engine fxload $(DRIVERS_TO_INSTALL)

bootstrap: $(NAME)-bootstrap
