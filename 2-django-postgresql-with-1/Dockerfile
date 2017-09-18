FROM 1-python3-uwsgi-nginx-with-0

LABEL maintainer="Michael Bradley <michaelsbradleyjr@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8

COPY apt.sh /
RUN bash apt.sh

COPY keep /build/2-django-postgresql-with-1

COPY build.sh /
RUN bash build.sh

RUN rm apt.sh build.sh
