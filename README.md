# INDI Server Container

Runs the INDI server with the requested set of drivers. See [INDI](http://indilib.org/) for more information about the INDI telescope control project.

## Running the containers

Ensure you've installed the required device drivers for your hardware on the host. You only need to install the base drivers that install firmware (e.g. libsbigudrv2, libqhy, etc.), there is no need to install any of the indi packages.

*note: the containers run as root to easily get access to USB and TTY devices, more fine-grained permissions for the `pi` user is left as an excercise for the reader*

Run the simulators

    sudo docker run -d -p 7624:7624 seanhoughton/indiserver:1.3.1 indi_simulator_telescope indi_simulator_ccd

Run real drivers (don't forget the `--privileged` flag to allow access to usb devices)

    sudo docker run --privileged -v /dev/bus/usb:/dev/bus/usb -d -p 7624:7624 seanhoughton/indiserver:1.3.1 indi_sbig_ccd indi_lx200gemini

Or, use docker-compose to make it easier to manage. Note that settings are stored in a named (aka persistent) volume named "config" that will persist accross container restarts. You could also map this to a directory. Also, you may have to modify the device volumes based on your specific hardware setup.

    # docker-compose.yml
    version: '2'
    services:
      indiserver:
        #image: seanhoughton/indiserver:1.3.1    # x86
        image: seanhoughton/rpi-indiserver:1.3.1 # rpi
        command: indi_sbig_ccd indi_qhy_ccd indi_robo_focus indi_lx200gemini
        restart: always
        privileged: true
        volumes:
          - /dev/bus/usb:/dev/bus/usb
          - /dev/ttyUSB0:/dev/ttyUSB0
          - config:/root/.indi
        ports:
          - 7624:7624 
    volumes:
      config:

Then run the stack with

    sudo docker-compose up -d



You can run the basic 


## Why use Docker?

Running services in docker provides some nice benefits

* Easy upgrade/downgrade - simply adjust the version number of the image you want to run
* Easy service management - if the server process stops for any reason Docker will restart it, including reboots
* Minimal setup - just install docker and go, no need to install anything related to indi (firmware loading drivers currently *do* need to be installed on the host)
* Reproducability - if you're having problems a developer can more easily reproduce it in a public container 

## Setup

The Makefile includes a `bootstrap` target which installs docker and any hardware drivers. You can customize the `DRIVERS_TO_INSTALL` value in the makefile. Currently the drivers must be installed on the host because the udev firmware loading rules don't work correctly inside of containers.

    make bootstrap


## Building the image (optional)

Dockerfiles are included for both x86 (linux) and Raspian base images. To build the images run `make`

    make image




