FROM 1-python3-uwsgi-nginx-with-0

LABEL maintainer="Michael Bradley <michaelsbradleyjr@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8

COPY build /docker-container/2-django-postgresql-with-1/build
RUN bash /docker-container/2-django-postgresql-with-1/build/install.sh

COPY run /docker-container/2-django-postgresql-with-1/run
RUN bash /docker-container/2-django-postgresql-with-1/build/setup.sh
