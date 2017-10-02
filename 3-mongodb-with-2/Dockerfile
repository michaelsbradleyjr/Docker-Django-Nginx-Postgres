FROM 2-django-postgresql-with-1

LABEL maintainer="Michael Bradley <michaelsbradleyjr@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8

COPY build /docker-container/3-mongodb-with-2/build
RUN bash /docker-container/3-mongodb-with-2/build/install.sh

COPY run /docker-container/3-mongodb-with-2/run
RUN bash /docker-container/3-mongodb-with-2/build/setup.sh
