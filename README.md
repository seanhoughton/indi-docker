# INDI Server Container

Runs the INDI server with the requested set of drivers. See [INDI](http://indilib.org/) for more information about the INDI telescope control project.

## Building the image

Dockerfiles are included for both x86 (linux) and Raspian base images. To build the images run `make`

    make


## Running the containers

Examples:

'''note: the containers run as root to easily get access to USB and TTY devices, more fine-grained permissions for the `pi` user can also be used'''

Run the simulators

    sudo docker run -d -p 7624:7624 seanhoughton/indiserver:1.3.1 indi_simulator_telescope indi_simulator_ccd

Run real drivers (don't forget the `--privileged` flag to allow access to usb devices)

    sudo docker run --privileged -v /dev/bus/usb:/dev/bus/usb -d -p 7624:7624 seanhoughton/indiserver:1.3.1 indi_sbig_ccd indi_lx200gemini

Or, use docker-compose to make it easier to manage. Note that settings are stored in a named (aka persistent) volume named "config" that will persist accross container restarts. You could also map this to a directory.

    # docker-compose.yml
    version: '2'
    services:
      indiserver:
        image: seanhoughton/rpi-indiserver:1.3.1
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


    sudo docker-compose up -d





