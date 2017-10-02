FROM 0-ubuntu-netselect

LABEL maintainer="Michael Bradley <michaelsbradleyjr@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8

COPY build /docker-container/1-python3-uwsgi-nginx-with-0/build
RUN bash /docker-container/1-python3-uwsgi-nginx-with-0/build/install.sh

COPY run /docker-container/1-python3-uwsgi-nginx-with-0/run
RUN bash /docker-container/1-python3-uwsgi-nginx-with-0/build/setup.sh

EXPOSE 80 8000
CMD ["/usr/local/bin/start"]
