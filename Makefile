VERSION=v1.3.1
IMAGE_PREFIX=seanhoughton/indiserver
TAG=$(VERSION)

.PHONY: x86_image rpi_image

x86_image:
	docker build -t $(IMAGE_PREFIX):$(TAG) -f Dockerfile.x86 .

rpi_image:
	docker build -t $(IMAGE_PREFIX)-rpi:$(TAG) -f Dockerfile.rpi .
