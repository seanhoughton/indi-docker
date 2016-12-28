VERSION=1.3.1
NAMESPACE=seanhoughton
TAG=$(VERSION)
UNAME_A=$(shell uname -a)

ifneq (,$(findstring raspberrypi,$(UNAME_A)))
    NAME=rpi-indiserver
    DOCKERFILE=Dockerfile.rpi
    DRIVERS_TO_INSTALL=libsbigudrv2_2.1.1_armhf.deb libqhy_0.1.8_armhf.deb
    LIBINDI_VERSION=1.3.1
else
    NAME=indiserver
    DOCKERFILE=Dockerfile.x86
endif

.PHONY: image push installdrivers-rpi
default: image


libindi-rpi.tgz:
	curl http://indilib.org/download/raspberry-pi/send/6-raspberry-pi/9-indi-library-for-raspberry-pi.html > libindi-rpi.tgz

image: libindi-rpi.tgz
	docker build -t $(NAMESPACE)/$(NAME):$(TAG) -f $(DOCKERFILE) .

push: image
	docker push $(NAMESPACE)/$(NAME):$(TAG)

bootstrap: libindi-rpi.tgz
	sudo apt-get update && sudo apt-get install -y docker-engine fxload
	tar -C /tmp -xzf libindi-rpi.tgz
	cd /tmp/libindi_$(LIBINDI_VERSION)_rpi && sudo dpkg -i $(DRIVERS_TO_INSTALL) && rm -r /tmp/libindi_$(LIBINDI_VERSION)_rpi
