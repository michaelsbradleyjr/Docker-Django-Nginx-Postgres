FROM ubuntu:16.04

LABEL maintainer="Michael Bradley <michaelsbradleyjr@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

COPY build /docker-container/0-ubuntu-netselect/build
RUN bash /docker-container/0-ubuntu-netselect/build/install.sh

ENV LANG en_US.UTF-8

COPY run /docker-container/0-ubuntu-netselect/run
RUN bash /docker-container/0-ubuntu-netselect/build/setup.sh
