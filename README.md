# INDI Server Container

Runs the INDI server with the requested set of drivers. See [INDI](http://indilib.org/) for more information about the INDI telescope control project.

Dockerfiles are included for both x86 (linux) and Raspian base images. To build the images use

    make rpi_image  # on Raspbian
    make x86_image  # on Linux

The entrypoint of the image is the indiserver. To run the container provide a list of drivers to run, the default is a set of simulators."

Examples:


A convenient way to run the simulators

    docker run -d -p 7624:7624 seanhoughton/indiserver:1.3.1 indi_simulator_telescope indi_simulator_ccd


The container must run in privileged mode to access physical devices (like USB)

    docker run --privileged -v /dev/bus/usb:/dev/bus/usb -d -p 7624:7624 seanhoughton/indiserver:1.3.1 indi_sbig_ccd indi_lx200gemini

