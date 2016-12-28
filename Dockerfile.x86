FROM ubuntu:latest
MAINTAINER Sean Houghton <sean.houghton@gmail.com>
RUN apt-get update && apt-get install -y software-properties-common
RUN apt-add-repository ppa:mutlaqja/ppa && apt-get update && apt-get install -y libindi1 indi-full
EXPOSE 7624
CMD echo $INDI_DRIVERS && indiserver -v $INDI_DRIVERS
