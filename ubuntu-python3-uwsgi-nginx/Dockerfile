FROM ubuntu-netselect:16.04

LABEL maintainer="Michael Bradley <michaelsbradleyjr@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

COPY apt.sh /
RUN bash apt.sh

COPY keep /build/ubuntu-python3-uwsgi-nginx

COPY build.sh /
RUN bash build.sh

RUN rm apt.sh build.sh

EXPOSE 80 8000
CMD ["/usr/local/bin/start"]
