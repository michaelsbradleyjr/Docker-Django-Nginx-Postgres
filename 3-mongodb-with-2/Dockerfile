FROM 2-django-postgresql-with-1

LABEL maintainer="Michael Bradley <michaelsbradleyjr@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8

COPY apt.sh /
RUN bash apt.sh

COPY keep /build/3-mongodb-with-2

COPY build.sh /
RUN bash build.sh

RUN rm apt.sh build.sh
