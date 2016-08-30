# INDI Server Container

Runs the INDI server with the requested set of drivers. See [INDI](http://indilib.org/) for more information about the INDI telescope control project.

|Variable|Description|
|---|---|
|INDI_DRIVERS|Space separated list of drivers to run|

Examples:


A convenient way to run the simulators

```
docker run -e INDI_DRIVERS='indi_simulator_telescope indi_simulator_ccd' -d -p 7624:7624 seanhoughton/indiserver:1.2
```


The container must run in privileged mode to access physical devices (like USB)

```
docker run --privileged -v /dev/bus/usb:/dev/bus/usb -e INDI_DRIVERS='indi_sbig_ccd indi_lx200gemini' -d -p 7624:7624 seanhoughton/indiserver:1.2
```