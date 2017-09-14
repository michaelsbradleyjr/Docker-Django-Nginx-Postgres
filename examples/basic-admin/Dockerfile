FROM ubuntu-python3-uwsgi-nginx:16.04

LABEL maintainer="Michael Bradley <michaelsbradleyjr@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

COPY keep /build/ubuntu-django-postgresql

COPY build.sh /
RUN bash build.sh && \
    rm build.sh
