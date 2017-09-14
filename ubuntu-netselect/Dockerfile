FROM ubuntu:16.04

LABEL maintainer="Michael Bradley <michaelsbradleyjr@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

COPY apt.sh /
RUN bash apt.sh

COPY keep /build/ubuntu-netselect

COPY build.sh /
RUN bash build.sh

RUN rm apt.sh build.sh
